view: mailchimp_audiences_clone {
  sql_table_name: looker_scratch.mailchimp_audiences_clone ;;

  dimension: audience {
    type: string
    sql: ${TABLE}."audience" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."email" ;;
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
