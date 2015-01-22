{
  "with": [
  {
    "select": {
      "fields": "*",
      "from": "prosper_loans"
    },
    "as": "referenced_table1"
  },
  {
    "select": {
      "fields": "*",
      "from": "prosper_loans"
    },
    "as": "referenced_table2"
  }
  ],
  "fields": "*",
  "from": "referenced_table"
}