view: tch_low_acuity_zips {
  sql_table_name: looker_scratch.tch_low_acuity_zips ;;

  dimension: num_lives {
    type: number
    sql: ${TABLE}."num_lives" ;;
  }

  measure: sum_lives {
    type: sum
    sql: ${num_lives} ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}."zipcode" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
