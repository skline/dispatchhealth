view: risk_assessments {
  sql_table_name: public.risk_assessments ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
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

  dimension_group: dob {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dob ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension_group: overridden {
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
    sql: ${TABLE}.overridden_at ;;
  }

  dimension: override_reason {
    type: string
    sql: ${TABLE}.override_reason ;;
  }

  dimension: protocol_id {
    type: number
    sql: ${TABLE}.protocol_id ;;
  }

  dimension: protocol_name {
    type: string
    sql: ${TABLE}.protocol_name ;;
  }

  dimension: protocol_score {
    type: number
    sql: ${TABLE}.protocol_score ;;
  }

  dimension: responses {
    type: string
    sql: ${TABLE}.responses ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.score ;;
  }

  dimension: risk_category {
    type: string
    sql: CASE
          WHEN ${score} >= 0 AND ${score} <= 5 THEN 'Green - Low Risk'
          WHEN ${score} > 5 AND ${score} < 11 THEN 'Yellow - Medium Risk'
          WHEN ${score} >= 11 THEN 'Red - High Risk'
          ELSE 'Unknown'
        END ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, protocol_name]
  }
}
