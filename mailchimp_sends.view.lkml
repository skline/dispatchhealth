view: mailchimp_sends {
  sql_table_name: looker_scratch.mailchimp_sends ;;

  dimension: campaign_id {
    type: string
    sql: ${TABLE}."campaign_id" ;;
  }

  dimension: email_address {
    type: string
    sql: ${TABLE}."email_address" ;;
  }

  dimension: email_id {
    type: string
    sql: ${TABLE}."email_id" ;;
  }

  dimension: list_id {
    type: string
    sql: ${TABLE}."list_id" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: count_distinct_sends {
    type: count_distinct
    sql: ${email_id} ;;
    sql_distinct_key: ${email_id} ;;

  }

  measure: count_distinct_opens {
    type: count_distinct
    sql: ${mailchimp_activities.email_id} ;;
    sql_distinct_key: ${mailchimp_activities.email_id} ;;
    filters: {
      field: mailchimp_activities.type
      value: "open"
    }
  }
  measure: count_distinct_clicks {
    type: count_distinct
    sql: ${mailchimp_activities.email_id} ;;
    sql_distinct_key: ${mailchimp_activities.email_id} ;;
    filters: {
      field: mailchimp_activities.type
      value: "click"
    }
  }

  measure: count_distinct_bounces {
    type: count_distinct
    sql: ${mailchimp_activities.email_id} ;;
    sql_distinct_key: ${mailchimp_activities.email_id} ;;
    filters: {
      field: mailchimp_activities.type
      value: "hard bounce"
    }
  }
}
