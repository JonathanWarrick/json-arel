{
  "fields": {
    "id": "id",
    "loan_type": "loan_type",
    "inflated_fico_score": "fico ^ 2"
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