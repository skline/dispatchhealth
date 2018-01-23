connection: "bi"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

explore: visit_facts {

  access_filter: {
    field: market_dimensions.market_name
    user_attribute: "market_name"
  }

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
    relationship: many_to_one
    sql_on: ${ed_diversion_survey_response_rate.market_dim_id} = ${visit_facts.market_dim_id} ;;
  }

  join: survey_response_facts_ed {
    relationship: many_to_one
    from: survey_response_facts
    sql_on: ${survey_response_facts_ed.visit_dim_number} = ${visit_facts.visit_dim_number}
    and ${survey_response_facts_ed.question_dim_id} = 3 ;;
  }

}
