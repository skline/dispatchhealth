view: protocols_questions {
  sql_table_name: public.protocols_questions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: protocol_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.protocol_id ;;
  }

  dimension: question_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.question_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, protocols.name, protocols.parent_protocol_id, questions.id, questions.name]
  }
}
