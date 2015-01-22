{
  "fields": ["loan_amount", "loan_id", "issue_date"],
  "from": "lending_club_loans",
  "where": {
    "loan_amount$gteq": 123
  },
  "limit": 100
}