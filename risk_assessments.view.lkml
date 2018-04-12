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

  dimension: protocol_name {
    type: string
    sql: ${TABLE}.protocol_name ;;
  }

  dimension: general_complaint {
    type: yesno
    sql: UPPER(${protocol_name}) = 'GENERAL COMPLAINT' ;;
  }

  measure: count_general_complaint {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: general_complaint
      value: "yes"
    }
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

  dimension: green_category {
    type: yesno
    sql: ${risk_category} = 'Green - Low Risk' ;;
  }

  measure: count_green {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: green_category
      value: "yes"
    }
  }

  dimension: yellow_category {
    type: yesno
    sql: ${risk_category} = 'Yellow - Medium Risk' ;;
  }

  measure: count_yellow {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: yellow_category
      value: "yes"
    }
  }

  dimension: red_category {
    type: yesno
    sql: ${risk_category} = 'Red - High Risk' ;;
  }

  measure: count_red {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: red_category
      value: "yes"
    }
  }

  measure: count_distinct {
    type: count_distinct
    sql: ${care_request_id} ;;
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
