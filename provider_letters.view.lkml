view: provider_letters {
  sql_table_name: looker_scratch.provider_letters ;;

  dimension: letters_sent {
    type: number
    sql: ${TABLE}.letters_sent ;;
  }

  dimension: providers {
    type: number
    sql: ${TABLE}.providers ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
