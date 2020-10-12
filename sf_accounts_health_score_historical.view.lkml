view: sf_accounts_health_score_historical {
  sql_table_name: looker_scratch.sf_accounts_health_score_historical ;;

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
    sql: ${TABLE}."date" ;;
  }

  dimension: health_score {
    type: number
    sql: ${TABLE}."health_score" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
