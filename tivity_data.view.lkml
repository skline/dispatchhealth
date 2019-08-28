view: tivity_data {
  sql_table_name: looker_scratch.tivity_data ;;

  dimension: client {
    type: string
    sql: ${TABLE}."client" ;;
  }

  dimension: eligible {
    type: number
    sql: ${TABLE}."eligible" ;;
  }

  dimension: enrollee {
    type: number
    sql: ${TABLE}."enrollee" ;;
  }

  dimension: participating_percent {
    type: number
    sql: ${TABLE}."participating_percent" ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: right(concat('0', ${TABLE}."zipcode"),5)  ;;
  }

  measure: sum_enrollee {
    type: sum_distinct
    sql_distinct_key: concat(${zipcode}, ${client}) ;;
    sql: ${enrollee} ;;
  }

  measure: sum_eligible {
    type: sum_distinct
    sql_distinct_key: concat(${zipcode}, ${client}) ;;
    sql: ${eligible} ;;
  }

  measure:enrollee_percent {
    type: number
    sql: ${sum_enrollee}/${sum_eligible} ;;
    value_format: "0.0%"
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
