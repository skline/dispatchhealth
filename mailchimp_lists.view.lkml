view: mailchimp_lists {
  sql_table_name: looker_scratch.mailchimp_lists ;;

  dimension: audience {
    type: string
    sql: ${TABLE}."audience" ;;
  }

  dimension: list_id {
    type: string
    sql: ${TABLE}."list_id" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
