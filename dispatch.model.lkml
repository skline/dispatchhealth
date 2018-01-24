connection: "bi"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

explore: visit_facts {

  # access_filter: {
  #   field: market_dimensions.market_name
  #   user_attribute: "market_name"
  # }

  join: market_dimensions {
    relationship: many_to_one
    sql_on: ${market_dimensions.id} = ${visit_facts.market_dim_id} ;;
  }

  join: channel_dimensions {
    relationship: many_to_one
    sql_on: ${channel_dimensions.id} = ${visit_facts.channel_dim_id} ;;
  }

  join: subtotal_over {
    relationship: many_to_one
    type: cross
  }

  join: request_type_dimensions {
    relationship: many_to_one
    sql_on: ${request_type_dimensions.id} = ${visit_facts.request_type_dim_id} ;;
  }

  join: visit_dimensions {
    relationship: many_to_one
    sql_on: ${visit_dimensions.visit_number} = ${visit_facts.visit_dim_number} ;;
  }

  join: car_dimensions {
    relationship: many_to_one
    sql_on: ${car_dimensions.id} = ${visit_facts.car_dim_id} ;;
  }

  join: ed_diversion_survey_response_rate {
    from: survey_response_facts
    relationship: many_to_one
    sql_on: ${ed_diversion_survey_response_rate.visit_dim_number} = ${visit_facts.visit_dim_number} ;;
    fields: [er_percent]
  }

  join: survey_response_facts {
    relationship: many_to_one
    sql_on: ${survey_response_facts.visit_dim_number} = ${visit_facts.visit_dim_number} ;;
  }

  join: ed_diversion_survey_response {
    from: survey_response_facts
    relationship: many_to_one
    sql_on: ${ed_diversion_survey_response.visit_dim_number} = ${visit_facts.visit_dim_number}
            WHERE ${ed_diversion_survey_response.question_dim_id} = 3 ;;
    fields: [care_request_id, visit_dim_number, answer_selection_value]
  }

  join: app_shift_summary_facts {
    relationship: many_to_one
    sql_on: ${app_shift_summary_facts.start_of_month_month} = ${visit_facts.local_accepted_month};;
  }

}
