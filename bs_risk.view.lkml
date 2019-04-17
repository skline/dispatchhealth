view: bs_risk {
  sql_table_name: looker_scratch.bs_risk ;;

  dimension: count_num {
    type: number
    sql: ${TABLE}.`sum(count_num)` ;;
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
