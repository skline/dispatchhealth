view: markets {
  # You can specify the table name if it's different from the view name:
  sql_table_name: jasperdb.market_dimensions ;;

  dimension: id {
    description: "Unique ID for each market"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: market_name {
    description: "Text description of each market"
    type: string
    sql: ${TABLE}.market_name ;;
  }
}
