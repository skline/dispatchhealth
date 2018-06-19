view: ed_diversion_survey_response_rate_clone {
  label: "ED Diversion Survey Response Rate"
  derived_table: {
    sql: select *
      from
      (SELECT   market_dim_id,  sum(case when (answer_selection_value = 'Emergency Room') then 1.0 else 0.0 end) / count(DISTINCT visit_facts_clone.care_request_id)::float as default_er_response_rate
      FROM     looker_scratch.survey_response_facts_clone
      JOIN     looker_scratch.visit_facts_clone
      ON       survey_response_facts_clone.visit_dim_number = visit_facts_clone.visit_dim_number
      WHERE    survey_response_facts_clone.question_dim_id = 3
      GROUP BY 1) ed_diversion_survey_response_rate
             ;;

      sql_trigger_value: SELECT max(visit_dim_number) ;;
      indexes: ["market_dim_id"]
    }
    dimension: market_dim_id {
      primary_key: yes
      type: number
      sql: ${TABLE}.market_dim_id ;;
    }
#
    dimension: er_percent {
      label: "ER percent"
      type: number
      sql: ${TABLE}.default_er_response_rate ;;
    }
  }
