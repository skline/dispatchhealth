view: centura_mssp_eligible {
  sql_table_name: looker_scratch.centura_mssp_eligible ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: group_member_id {
    type: string
    sql: ${TABLE}.group_member_id ;;
  }

  dimension: match_value {
    type: string
    sql: ${TABLE}.match_value ;;
  }

  dimension: plan {
    type: string
    sql: ${TABLE}.plan ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
