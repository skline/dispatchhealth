view: spr_zips {
  sql_table_name: looker_scratch.spr_zips ;;

  dimension: population {
    type: number
    sql: ${TABLE}.population ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
