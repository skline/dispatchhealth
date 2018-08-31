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

  dimension: role {
    type: string
    sql: ${TABLE}.role ;;
  }

  dimension: pilot {
    type: yesno
    sql: ${agent_name} in ('Yassine, Freddy' , 'Hill, Veronica') ;;
  }

  dimension:pilot_breakdown {
    type: string
    sql: case when ${pilot} or ${agent_name} is null then ${agent_name}
           else 'Not in Pilot' end;;

  }


  measure: count {
    type: count
    drill_fields: [agent_name]
  }
}
