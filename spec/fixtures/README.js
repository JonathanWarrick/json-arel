{
  "fields": {
    "id": "id",
    "loan_type": "loan_type",
    "fico ^ 2": "inflated_fico_score"
  },
  "from": "loans",
  "where": {
    "loan_amount$gteq": 123
  },
  "group": "loan_type",
  "order": [["id", "ASC"]],
  "limit": 100,
  "offset": 200
}