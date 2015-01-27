# json-arel

Represent SQL expressions as JSON objects. Relies on the outstanding
[rails/json-arel](https://github.com/rails/arel) library to do most of the
heavy lifting. 

Also, the default is to encode the queries in the Postgres SQL dialect, but the
library should support almost any dialect supported by Rails.

## Example

Convert

```javascript
{
  "fields": {
    "inflated_fico_score": "fico ^ 2"
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
resolver = JSONArel::Resolver.new(schema)
resolver.resolve
```

## Operators

<table>
<thead>
<tr>
  <th>Operator</th>
  <th>Expression</th>
  <th>Example</th>
  <th>Meaning</th>
</tr>
</thead>
<tbody>
<tr>
<td>`$eq`</td>
<td>Equals</td>
<td>`{"fico$eq": 700}</td>
<td>FICO = 700</td>
</tr>

<tr>
<td>`$not_eq`</td>
<td>Not Equals</td>
<td>`{"fico$not_eq": 700}</td>
<td>FICO != 700</td>
</tr>

<tr>
<td>`$gt`</td>
<td>Equals</td>
<td>`{"fico$gt": 700}</td>
<td>FICO > 700</td>
</tr>

<tr>
<td>`$gteq`</td>
<td>≥</td>
<td>`{"fico$gteq": 700}</td>
<td>FICO = 700</td>
</tr>

</tbody>
</table>
