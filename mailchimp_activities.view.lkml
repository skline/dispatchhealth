view: mailchimp_activities {
  sql_table_name: looker_scratch.mailchimp_activities ;;

  dimension: email_id {
    type: string
    sql: ${TABLE}."email_id" ;;
  }

  dimension: link {
    type: string
    sql: ${TABLE}."link" ;;
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

  dimension: type {
    type: string
    sql: ${TABLE}."type" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: campaign_id {
    type: string
    sql: ${TABLE}."campaign_id" ;;
  }

}
