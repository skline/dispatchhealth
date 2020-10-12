view: propensity_atl {
  sql_table_name: looker_scratch.propensity_atl ;;

  dimension: prospect_count {
    type: number
    sql: ${TABLE}.prospect_count ;;
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
