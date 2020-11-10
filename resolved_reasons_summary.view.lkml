view: resolved_reasons_summary {
  sql_table_name: looker_scratch.resolved_reasons_summary ;;
  dimension: resolved_employee {
    type: string
    sql: ${TABLE}."resolved_employee" ;;
  }
  dimension: department {
    label: "Department"
    type: string
    sql: ${TABLE}."department" ;;
  }
}
