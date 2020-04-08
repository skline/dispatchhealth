view: risk_assessment_covid_19_questions {

  derived_table: {
      sql:
  SELECT
    care_request_id,
    count (distinct care_request_id) as count,
    responses::json#>'{questions,0}'->>'name' AS covid_19_question0,
    responses::json#>'{questions,0}'->>'answer' AS covid_19_answer0,
    responses::json#>'{questions,1}'->>'name' AS covid_19_question1,
    responses::json#>'{questions,1}'->>'answer' AS covid_19_answer1,
    responses::json#>'{questions,2}'->>'name' AS covid_19_question2,
    responses::json#>'{questions,2}'->>'answer' AS covid_19_answer2
    FROM risk_assessments
    WHERE care_request_id IS NOT NULL AND (type != 'HighRiskAssessment' OR type IS NULL)
    group by care_request_id, responses
    ORDER BY care_request_id DESC
    ;;

    sql_trigger_value: SELECT MAX(created_at) FROM risk_assessments ;;
    indexes: ["care_request_id"]

    }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: covid_19_question0 {
    description: "Question: Have you tested positive for COVID-19?"
    type: string
    sql: ${TABLE}.covid_19_question0 ;;
  }

  dimension: covid_19_answer0 {
    description: "Answer: Have you tested positive for COVID-19."
    type:  string
    sql: ${TABLE}.covid_19_answer0 ;;
  }

  dimension: covid_19_question1 {
    description: "Question: Has anyone in your household tested positive or been diagnosed with COVID-19?"
    type: string
    sql: ${TABLE}.covid_19_question1 ;;
  }

  dimension: covid_19_answer1 {
    description: "Answer: Has anyone in your household tested positive or been diagnosed with COVID-19."
    type: string
    sql: ${TABLE}.covid_19_answer1 ;;
  }

  dimension: covid_19_question2 {
    description: "Question: Do you have a COVID-19 test that is pending?"
    type: string
    sql: ${TABLE}.covid_19_question2 ;;
  }

  dimension: covid_19_answer2 {
    description: "Answer: : Do you have a COVID-19 test that is pending?"
    type: string
    sql: ${TABLE}.covid_19_answer2 ;;
  }

  dimension: covid_19_answer_yes_any {
    description: "Patient asnwered yes to any of the three COVID-19 questions"
    type: yesno
    sql: lower(${covid_19_answer0}) =  'yes' OR lower(${covid_19_answer1}) = 'yes' OR lower(${covid_19_answer0}) =  'yes' ;;
  }

  dimension: covid_19_answer_yes_positive {
    description: "Patient asnwered yes to personally or someone in their household testing positive for COVID-19"
    type: yesno
    sql: lower(${covid_19_answer0}) =  'yes' OR lower(${covid_19_answer1}) = 'yes' ;;
  }

  measure: count_answer0 {
    label: "Answer: Have you tested positive for COVID-19"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: covid_19_answer0
      value: "Yes"
    }
  }

  measure: count_answer1 {
    label: "Answer: Has anyone in your household tested positive or been diagnosed with COVID-19"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: covid_19_answer1
      value: "Yes"
    }
  }

  measure: count_answer2 {
    label: "Answer: Do you have a COVID-19 test that is pending"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: covid_19_answer2
      value: "Yes"
    }
  }

  measure: count_answer_yes_any {
    label: "Patient answered yes to any of the three COVID-19 Questions"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: covid_19_answer_yes_any
      value: "Yes"
    }
  }


  measure: count_covid_19_answer_yes_positive {
    label: "Patient asnwered yes to personally or someone in their household testing positive for COVID-19"
    type: count_distinct
    sql: ${care_requests.id} ;;
    filters: {
      field: covid_19_answer_yes_positive
      value: "Yes"
    }
  }


  }
