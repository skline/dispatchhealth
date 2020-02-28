view: sf_priority_accounts {
  sql_table_name: looker_scratch.sf_priority_accounts ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date"  + interval '7' day;;
  }

  dimension: priority_action {
    type: string
    sql: ${TABLE}."priority_action" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
