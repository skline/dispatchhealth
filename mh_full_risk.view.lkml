view: mh_full_risk {
  sql_table_name: looker_scratch.mh_full_risk ;;

  dimension: member_count {
    type: number
    sql: ${TABLE}.member_count ;;
  }

  dimension: plan {
    type: string
    sql: ${TABLE}.plan ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_members {
    type: number
    sql: sum(${member_count}) ;;
  }

}
