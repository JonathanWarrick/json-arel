{
  "fields": {
    "fico ^ 2 + 200": "inflated_fico"
  },
  "from": "lending_club_loans",
  "where": {
    "loan_amount$gteq": 123
  },
  "limit": 100,
  "offset": 200
}