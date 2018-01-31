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
    sql_on: ${visit_dimensions.care_request_id} = ${visit_facts.care_request_id} ;;
  }

  join: car_dimensions {
    relationship: many_to_one
    sql_on: ${car_dimensions.id} = ${visit_facts.car_dim_id} ;;
  }

  join: ed_diversion_survey_response_rate {
    relationship: many_to_one
    sql_on: ${ed_diversion_survey_response_rate.market_dim_id} = ${visit_facts.market_dim_id} ;;
  }

  join: survey_response_facts {
    relationship: many_to_one
    sql_on: ${survey_response_facts.visit_dim_number} = ${visit_facts.visit_dim_number} ;;
  }

  join: ed_diversion_survey_response {
    relationship: many_to_one
    sql_on: ${ed_diversion_survey_response.visit_dim_number} = ${visit_facts.visit_dim_number} ;;
  }

  join: app_shift_summary_facts {
    relationship: many_to_one
    sql_on: ${app_shift_summary_facts.start_of_month_month} = ${visit_facts.local_accepted_month};;
  }

  join: provider_dimensions {
    relationship: many_to_one
    sql_on: ${provider_dimensions.id} = ${visit_facts.provider_dim_id};;
  }

  join: app_shift_planning_facts {
    from: shift_planning_facts
    type: inner
    relationship:  many_to_one
    sql_on:(${app_shift_planning_facts.employee_name} = ${provider_dimensions.shift_app_name}
          and date(${app_shift_planning_facts.local_actual_start_time})=date(${visit_facts.local_accepted_time})
          and ${app_shift_planning_facts.schedule_role} in('NP/PA', 'Training/Admin'))
          or (${visit_facts.nppa_shift_id} = ${app_shift_planning_facts.shift_id})

      ;;
  }

  join: app_shift_planning_shifts {
    from: shift_planning_shifts
    type: inner
    relationship: many_to_one
    sql_on: ${app_shift_planning_facts.shift_id} = ${app_shift_planning_facts.shift_id};;
  }

  join: primary_payer_dimension_charge {
    sql_on: ${primary_payer_dimension_charge.visit_dim_number} = ${visit_facts.visit_dim_number}  ;;
  }

  join: transaction_facts {
    sql_on: ${transaction_facts.visit_dim_number} = ${visit_dimensions.visit_number}  ;;
  }

  join: primary_payer_dimensions {
    sql_on: ${transaction_facts.primary_payer_dim_id} = ${primary_payer_dimensions.id}  ;;
  }

  join: payer_dimensions {
    sql_on: ${transaction_facts.payer_dim_id} = ${payer_dimensions.id}  ;;
  }

  join: patient_dimensions {
    sql_on: ${visit_facts.patient_dim_id} = ${patient_dimensions.id}  ;;
  }

  join: patient_facts {
    sql_on: ${visit_dimensions.dashboard_patient_id} = ${patient_facts.dashboard_patient_id}  ;;
  }

  join: pcp_dimensions {
    sql_on: ${patient_facts.pcp_dim_id} = ${pcp_dimensions.id}  ;;
  }

  join: budget_projections_by_market {
    sql_on: ${visit_facts.market_dim_id} = ${budget_projections_by_market.market_dim_id}
            AND ${visit_dimensions.local_visit_month}=${budget_projections_by_market.month_month};;
  }

  join: budget_projections_by_market_future {
    from: budget_projections_by_market
    sql_on: ${market_dimensions.id} = ${budget_projections_by_market_future.market_dim_id};;
  }
  join: market_start_date {
    sql_on: ${market_start_date.market_dim_id} = ${market_dimensions.id} ;;

  }

  join: channel_start_date {
    sql_on: ${channel_start_date.market_dim_id} = ${visit_facts.market_dim_id}
            and  ${channel_start_date.channel_dim_id} = ${visit_facts.channel_dim_id} ;;

  }
  join:  capacity_model_processed {
    sql_on: ${market_dimensions.id} =  ${capacity_model_processed.market_dim_id}
            and ${channel_dimensions.id} = ${capacity_model_processed.channel_dim_id}
    ;;
    }

  join:  location_dimensions {
    sql_on: ${visit_facts.location_dim_id} =  ${location_dimensions.id}
    ;;
  }
}

explore: incontact {
  join: adwords_call_data {
    sql_on: ${adwords_call_data.end_time_raw} = ${incontact.end_time_raw}
    or ${adwords_call_data.end_time_plus_one} = ${incontact.end_time_raw}
    or ${adwords_call_data.end_time_minus_one}= ${incontact.end_time_raw}
    ;;
  }
}
