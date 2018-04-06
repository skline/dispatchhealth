view: risk_assessments_bi {
  sql_table_name: looker_scratch.risk_assessments_bi ;;

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

  dimension: score_category {
    description: "Risk score category: green (0 - 5), yellow (6 - 10), or red (11+)"
    type: string
    sql: CASE
          WHEN ${score} <= 5 THEN 'green'
          WHEN ${score} > 5 AND ${score} <=10 THEN 'yellow'
          WHEN ${score} > 10 THEN 'red'
        END ;;
    drill_fields: [protocol_name, score]
  }

  dimension: green_category {
    type: yesno
    sql: ${score_category} = 'green' ;;
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
    sql: ${score_category} = 'yellow' ;;
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
    sql: ${score_category} = 'red' ;;
  }

  measure: count_red {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: red_category
      value: "yes"
    }
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
