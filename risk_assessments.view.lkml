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
    sql: CASE
      WHEN ${TABLE}.protocol_name LIKE '%Vision/eye%' THEN 'Vision Problem'
      WHEN ${TABLE}.protocol_name LIKE '%Extremity Injury/Pain%' THEN 'Extremity Injury'
      WHEN ${TABLE}.protocol_name LIKE '%Upper Respiratory Infection%' THEN 'Cough/URI'
      ELSE INITCAP(${TABLE}.protocol_name)
    END;;
  }

  measure: protocol_count {
    type: count_distinct
    sql: ${protocol_name} ;;
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

  measure: general_complaint_percent{
    type: number
    value_format: "0.0%"
    sql: (${count_general_complaint}::float/${count_distinct}::float) ;;
  }

  dimension: responses {
    type: string
    sql: ${TABLE}.responses ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}.score ;;
  }

  measure: average_score {
    type: average
    sql: ${score} ;;
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

  measure: count_yellow_eslcated_phone {
    type: count_distinct
    sql: case when ${care_request_flat_exact.escalated_on_phone} and ${yellow_category}  then ${care_request_id}  else null end ;;
    sql_distinct_key: ${care_request_id} ;;
  }

  measure: count_red_eslcated_phone {
    type: count_distinct
    sql: case when ${care_request_flat_exact.escalated_on_phone} and ${red_category}  then ${care_request_id}  else null end ;;
    sql_distinct_key: ${care_request_id} ;;

  }

  measure: count_green_esclated_phone {
    type: count_distinct
    sql: case when ${care_request_flat_exact.escalated_on_phone} and ${green_category}  then ${care_request_id}  else null end ;;
    sql_distinct_key: ${care_request_id} ;;
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
