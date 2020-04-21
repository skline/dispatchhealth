view: ut_membership {
  sql_table_name: looker_scratch.ut_membership ;;

  dimension: ut_membership {
    type: number
    sql: round(${TABLE}.ut_membership,0) ;;
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
