view: mh_partial_risk {
  sql_table_name: looker_scratch.mh_partial_risk ;;

  dimension: arrangement {
    type: string
    sql: ${TABLE}.arrangement ;;
  }

  dimension: member_count {
    type: number
    sql: ${TABLE}.member_count ;;
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
