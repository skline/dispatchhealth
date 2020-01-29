view: sf_activities {
  sql_table_name: looker_scratch.sf_activities ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}."account_name" ;;
  }

  dimension: activity_id {
    type: string
    sql: ${TABLE}."activity_id" ;;
  }

  dimension: assigned {
    type: string
    sql: ${TABLE}."assigned" ;;
  }

  dimension: channel_type {
    type: string
    sql: ${TABLE}."channel_type" ;;
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
    sql: ${TABLE}."date" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: result {
    type: string
    sql: ${TABLE}."result" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."subject" ;;
  }

  measure: count {
    type: count
    drill_fields: [account_name]
  }
}
