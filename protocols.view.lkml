view: protocols {
  sql_table_name: public.protocols ;;

  dimension: parent_protocol_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.parent_protocol_id ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}.deleted_by ;;
  }

  dimension: general {
    type: yesno
    sql: ${TABLE}.general ;;
  }

  dimension: high_risk {
    type: yesno
    sql: ${TABLE}.high_risk ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
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

  dimension_group: modified {
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
    sql: ${TABLE}.modified_at ;;
  }

  dimension: modified_by {
    type: string
    sql: ${TABLE}.modified_by ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension_group: published {
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
    sql: ${TABLE}.published_at ;;
  }

  dimension: published_by {
    type: string
    sql: ${TABLE}.published_by ;;
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      parent_protocol_id,
      name,
      protocol_keywords.count,
      protocols_questions.count,
      questions.count,
      rules.count
    ]
  }
}
