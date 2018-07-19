view: csc_agent_location {
  sql_table_name: looker_scratch.csc_agent_location ;;

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  measure: count {
    type: count
    drill_fields: [agent_name]
  }
}
