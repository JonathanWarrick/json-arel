{
  "with": [
  {
    "select": {
      "fields": "*",
      "from": "prosper_loans"
    },
    "as": "referenced_table"
  }
  ],
  "fields": "*",
  "from": "referenced_table"
}