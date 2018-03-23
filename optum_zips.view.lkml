view: optum_zips {
  sql_table_name: looker_scratch.optum_zips ;;

  dimension: patients {
    type: number
    sql: ${TABLE}.patients ;;
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
