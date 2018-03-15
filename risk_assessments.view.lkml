view: risk_assessments {
  sql_table_name: looker_scratch.risk_assessments ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: protocol_name {
    type: string
    sql: ${TABLE}.protocol_name ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, protocol_name]
  }
}
