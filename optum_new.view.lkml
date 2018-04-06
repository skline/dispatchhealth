view: optum_new {
  sql_table_name: looker_scratch.optum_new ;;

  dimension: dh_service_area {
    type: string
    sql: ${TABLE}.dh_service_area ;;
  }

  dimension: mbrs {
    type: number
    sql: ${TABLE}.mbrs ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: zone {
    type: string
    sql: ${TABLE}.zone ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
