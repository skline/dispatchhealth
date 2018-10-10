view: rules {
  sql_table_name: public.rules ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: end_age {
    type: number
    sql: ${TABLE}.end_age ;;
  }

  dimension_group: inserted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.inserted_at ;;
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

  dimension: response_type_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.response_type_id ;;
  }

  dimension: start_age {
    type: number
    sql: ${TABLE}.start_age ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      response_types.id,
      response_types.name,
      questions.id,
      questions.name,
      protocols.name,
      protocols.parent_protocol_id,
      rules_genders.count
    ]
  }
}
