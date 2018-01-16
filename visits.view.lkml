view: visits {
  # You can specify the table name if it's different from the view name:
  sql_table_name: jasperdb.visit_facts ;;

  dimension: id {
    description: "Unique ID for each visit"
    type: number
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension: market_dim_id {
    description: "Unique ID for each market"
    type: number
    primary_key: no
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: chief_complaint {
    description: "Chief complaint for each visit"
    type: string
    sql: ${TABLE}.chief_complaint ;;
  }

  dimension_group: local_requested_time {
    description: "The date when the visit was requested"
    type: time
    timeframes: [date, week, month, year]
    sql: ${TABLE}.local_requested_time ;;
  }

  measure: total_visits {
    description: "Count of visits"
    type: count
    sql: ${id} ;;
  }
}
