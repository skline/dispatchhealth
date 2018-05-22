view: dtc_categorization {
  sql_table_name: looker_scratch.dtc_categorization ;;

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }


  dimension: high_level_category {
    type: string
    sql: ${TABLE}.high_level_category ;;
  }

  dimension_group: mountain_created {
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
    sql: ${TABLE}.mountain_created ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
