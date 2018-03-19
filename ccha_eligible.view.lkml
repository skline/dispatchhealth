view: ccha_eligible {
  sql_table_name: looker_scratch.ccha_eligible ;;

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

  measure: count {
    type: count
    drill_fields: [id]
  }
}
