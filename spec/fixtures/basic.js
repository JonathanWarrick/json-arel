{
  "fields": "*",
  "from": "lending_club_loans",
  "where": {
    "loan_status$in": null,
    "loan_id": 1234,
    "loan_amount$gteq": 123
  },
  "limit": 100
}