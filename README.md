# ruby-json-sql

Represent SQL queries in JSON.

## Example

Convert

```javascript
{
  "fields": {
    "fico ^ 2": "inflated_fico_score"
  },
  "from": "loans",
  "where": {
    "loan_amount$gteq": 123
  },
  "limit": 100,
  "offset": 200
}
```

into

```sql
SELECT fico ^ 2 as inflated_fico_score FROM loans WHERE loan_amount >= 123 LIMIT 100 OFFSET 200
```

## Usage

```ruby
schema = JSON.parse(File.open('schema.js').read)
resolver = Resolver.new(schema)
resolver.resolve
```