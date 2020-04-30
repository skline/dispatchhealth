view: mailchimp_campaigns {
  sql_table_name: looker_scratch.mailchimp_campaigns ;;

  dimension: campaign_id {
    type: string
    sql: ${TABLE}."campaign_id" ;;
  }

  dimension: from_name {
    type: string
    sql: ${TABLE}."from_name" ;;
  }

  dimension: list_id {
    type: string
    sql: ${TABLE}."list_id" ;;
  }

  dimension: reply_to {
    type: string
    sql: ${TABLE}."reply_to" ;;
  }

  dimension: subject {
    type: string
    sql: ${TABLE}."subject" ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."timestamp" ;;
  }

  measure: count {
    type: count
    drill_fields: [from_name]
  }
}
