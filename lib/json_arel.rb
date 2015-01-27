require 'arel'
require 'active_record'

module JSONArel
  class Resolver

    VALID_OPERATORS = %w[$eq $not_eq $gt $gteq $lt $lteq $in]

    def default_active_record_opts
      {
        :adapter => 'postgresql',
        :database => 'explorer_development'
      }
    end

    def initialize(tree, active_record_opts=default_active_record_opts)
      @tree = tree
      ActiveRecord::Base.establish_connection(active_record_opts)
    end

    def resolve
      resolve_node(@tree).to_sql
    end

    def resolve_node(node)

      # (with) SELECT (fields) FROM (from) (join) WHERE (CONDITIONS) (GROUPBY) (LIMIT)
      table = Arel::Table.new(node['from'])

      # Does it contain a CTE?
      ctes = (node['with'] || []).map do |cte|
        Arel::Nodes::As.new(Arel::Table.new(cte['as'].to_sym), resolve_node(cte['select']))
      end

      # Resolve the SELECT fields
      if node['fields'].class == String
        # Is it a single string we're selecting?
        node['fields'] = Arel.sql(node['fields'])
      elsif node['fields'].class == Array
        node['fields'] = node['fields'].map {|x| Arel.sql(x) }
      elsif node['fields'].class == Hash
        # Is it a hash?
        node['fields'] = node['fields'].invert.map do |k,v|
          Arel.sql(k).as(v)
        end
      end

      # Resolve WHERE
      node['where'] = (node['where'] || {}).map do |key, val|
        field, comparator, value = parse_where(key, val)
        table[field.to_sym].send(comparator, val)
      end

      # Evaluate.
      if node['where'].length > 0
        node['where'].each do |condition|
          table = table.where(condition)
        end
      end
      expr = table.project(node['fields'])

      # TODO: support JOIN

      # Resolve GROUP BY
      node['group'] ||= []
      if node['group'].class == String
        node['group'] = [node['group']]
      end
      node['group'] = node['group'].map {|x| Arel.sql(x) }
      expr = expr.group(node['group']) if node['group'].length > 0

      # Evaluate CTEs
      expr = expr.with(ctes) if ctes.length > 0

      # Resolve LIMIT / OFFSET
      expr.take(node['limit']) if node['limit']
      expr.skip(node['offset']) if node['offset']

      expr
    end

    def parse_where(field, val)
      # TODO: Support OR
      # Return func, params.
      operator_index = field.index('$')
      if operator_index
        field, comparator = field[0..operator_index-1], field[operator_index..field.length]
        if !VALID_OPERATORS.include? comparator
          raise ResolverError, "#{comparator} is an invalid filter expression."
        end
      else
        comparator = '$eq'
      end
      return field, comparator[1..-1], val
    end

  end

  class ResolverError < StandardError
  end
end
