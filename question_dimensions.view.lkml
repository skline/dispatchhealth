view: question_dimensions {
  sql_table_name: jasperdb.question_dimensions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: question_text {
    type: string
    sql: ${TABLE}.question_text ;;
  }

  dimension: nps_question {
    type: yesno
    sql: ${TABLE}.question_text = 'How likely is it that you would recommend this service to a friend or colleague?' ;;
  }

  dimension: sub_type {
    type: string
    sql: ${TABLE}.sub_type ;;
  }

  dimension: survey_monkey_question_id {
    type: string
    sql: ${TABLE}.survey_monkey_question_id ;;
  }

  dimension: type_family {
    type: string
    sql: ${TABLE}.type_family ;;
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
    drill_fields: [id]
  }
}
