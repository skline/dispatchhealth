connection: "dashboard"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project


explore: care_requests {

  sql_always_where: ${deleted_raw} IS NULL AND
  (${care_request_flat.secondary_resolved_reason} NOT IN ('Test Case', 'Duplicate') OR ${care_request_flat.secondary_resolved_reason} IS NULL) ;;

  access_filter: {
    field: markets.name
    user_attribute: "market_name"
  }


# Join all Athena data warehouse feed tables -- DE
  join: athenadwh_patient_insurances_clone {
    relationship: one_to_many
    sql_on: ${patients.ehr_id} = ${athenadwh_patient_insurances_clone.patient_id}::varchar
      AND ${athenadwh_patient_insurances_clone.insurance_package_id}::int != 0;;
  }

  join: athenadwh_payers_clone {
    relationship: many_to_one
    sql_on: ${athenadwh_patient_insurances_clone.insurance_package_id} = ${athenadwh_payers_clone.insurance_package_id} ;;
  }

  join: athenadwh_clinical_encounters_clone {
    relationship:  one_to_many
    sql_on: ${patients.ehr_id} = ${athenadwh_clinical_encounters_clone.patient_id}::varchar AND
      ${athenadwh_clinical_encounters_clone.appointment_id}::varchar = ${care_requests.ehr_id};;
  }

  join: athenadwh_provider_clone {
    relationship: many_to_one
    sql_on: ${athenadwh_clinical_encounters_clone.provider_id} = ${athenadwh_provider_clone.provider_id} ;;
    sql_where: ${athenadwh_provider_clone.provider_id} != ${athenadwh_provider_clone.supervising_provider_id} ;;
  }

  join: athenadwh_supervising_provider_clone {
    from: athenadwh_provider_clone
    relationship: many_to_one
    sql_on: ${athenadwh_provider_clone.supervising_provider_id} = ${athenadwh_supervising_provider_clone.provider_id} ;;
  }

  join: athenadwh_appointments_clone {
    relationship: one_to_one
    sql_on: ${athenadwh_clinical_encounters_clone.appointment_id} = ${athenadwh_appointments_clone.appointment_id} ;;
  }

  join: athenadwh_clinical_encounter_provider {
    from: athenadwh_clinical_providers_clone
    relationship: one_to_one
    sql_on:  ${athenadwh_clinical_encounters_clone.provider_id} = ${athenadwh_clinical_encounter_provider.clinical_provider_id} ;;
  }

  join: athenadwh_claims_clone {
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.appointment_id} = ${athenadwh_claims_clone.claim_appointment_id} ;;
  }

  join: athenadwh_document_crosswalk_clone {
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.patient_id} = ${athenadwh_document_crosswalk_clone.patient_id} AND
            ${athenadwh_clinical_encounters_clone.chart_id} = ${athenadwh_document_crosswalk_clone.chart_id} ;;
  }

  join: athenadwh_letters_encounters {
    from:  athenadwh_documents_clone
    relationship:  one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_letters_encounters.clinical_encounter_id} AND
            ${athenadwh_letters_encounters.document_class} IN ('LETTER', 'ENCOUNTERDOCUMENT') AND
            (${athenadwh_letters_encounters.document_subclass} != 'LETTER_PATIENTCORRESPONDENCE' OR ${athenadwh_letters_encounters.document_subclass} IS NULL) AND
            ${athenadwh_letters_encounters.status} != 'DELETED';;
  }

  join: athenadwh_prescriptions {
    from:  athenadwh_documents_clone
    relationship:  one_to_many
    sql_on:  ${athenadwh_prescriptions.clinical_encounter_id} = ${athenadwh_clinical_encounters_clone.clinical_encounter_id} AND
            ${athenadwh_prescriptions.document_class} = 'PRESCRIPTION' AND
            ${athenadwh_prescriptions.status} != 'DELETED';;
  }

  join: athenadwh_dme {
    from:  athenadwh_documents_clone
    relationship:  one_to_many
    sql_on:  ${athenadwh_dme.clinical_encounter_id} = ${athenadwh_clinical_encounters_clone.clinical_encounter_id} AND
      ${athenadwh_dme.document_class} = 'DME' AND
      ${athenadwh_dme.status} != 'DELETED' ;;
  }

  join: athenadwh_lab_imaging_results {
    from:  athenadwh_documents_clone
    relationship:  one_to_one
    sql_on: ${athenadwh_document_crosswalk_clone.document_id} = ${athenadwh_lab_imaging_results.document_id} AND
      ${athenadwh_lab_imaging_results.document_class} IN ('IMAGINGRESULT', 'LABRESULT') AND
      ${athenadwh_lab_imaging_results.status} != 'DELETED' ;;
  }

  join: athenadwh_lab_imaging_providers {
    from: athenadwh_clinical_providers_clone
    relationship: one_to_one
    sql_on: ${athenadwh_lab_imaging_results.clinical_provider_id} = ${athenadwh_lab_imaging_providers.clinical_provider_id} ;;
  }

  join: athenadwh_labs {
    from:  athenadwh_documents_clone
    relationship:  one_to_many
    sql_on:  ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_labs.clinical_encounter_id} AND
    ${athenadwh_labs.document_class} = 'ORDER' AND
    ${athenadwh_labs.status} != 'DELETED' ;;
    # sql_where:  ${athenadwh_clinical_results_clone.clinical_order_type_group} = 'LAB' ;;
    # AND ${athenadwh_clinical_results_clone.clinical_order_type_group} = 'LAB';;
  }

  join: athenadwh_orders {
    from:  athenadwh_documents_clone
    relationship:  one_to_many
    sql_on:  ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_orders.clinical_encounter_id} AND
      ${athenadwh_orders.document_class} = 'ORDER' AND
      ${athenadwh_orders.status} != 'DELETED' ;;
  }

  join: athenadwh_order_providers {
    from: athenadwh_clinical_providers_clone
    relationship: one_to_one
    sql_on: ${athenadwh_orders.clinical_provider_id} = ${athenadwh_order_providers.clinical_provider_id} ;;
  }

  join: athenadwh_referrals {
    from:  athenadwh_documents_clone
    relationship:  one_to_many
    sql_on:  ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_referrals.clinical_encounter_id} AND
      ${athenadwh_referrals.clinical_order_type} LIKE '%REFERRAL%' AND
      ${athenadwh_referrals.status} != 'DELETED' ;;
  }

  join: athenadwh_homehealth_referrals {
    from:  athenadwh_documents_clone
    relationship:  one_to_many
    sql_on:  ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_homehealth_referrals.clinical_encounter_id} AND
      ${athenadwh_homehealth_referrals.clinical_order_type} LIKE 'HOME HEALTH%REFERRAL' AND
      ${athenadwh_homehealth_referrals.status} != 'DELETED' ;;
  }

  join: athenadwh_documents_clone {
    relationship: one_to_many
    sql_on:  ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_documents_clone.clinical_encounter_id};;
  }

  join: athenadwh_referral_providers {
    from: athenadwh_clinical_providers_clone
    relationship: one_to_one
    sql_on: ${athenadwh_referrals.clinical_provider_id} = ${athenadwh_referral_providers.clinical_provider_id} ;;
  }

  join: athenadwh_documents_provider {
    from: athenadwh_clinical_providers_clone
    relationship: one_to_one
    sql_on: ${athenadwh_documents_clone.clinical_provider_id} = ${athenadwh_documents_provider.clinical_provider_id} ;;
  }

  join: athenadwh_clinical_results_clone {
    relationship: one_to_one
    sql_on: ${athenadwh_documents_clone.document_id} = ${athenadwh_clinical_results_clone.document_id} ;;
  }

  join: athenadwh_clinical_letters_clone {
    relationship:  one_to_one
    sql_on: ${athenadwh_letters_encounters.document_id} = ${athenadwh_clinical_letters_clone.document_id} ;;
  }

  join: athenadwh_clinical_providers_fax_clone {
    sql_on: ${athenadwh_clinical_providers_fax_clone.clinical_provider_id} = ${athenadwh_letter_recipient_provider.clinical_provider_id} ;;
  }
  join: faxes_sent {
    sql_on: ${athenadwh_clinical_providers_fax_clone.fax} = ${faxes_sent.fax} ;;
  }

  join: athenadwh_letter_recipient_provider {
    from: athenadwh_clinical_providers_clone
    relationship:  many_to_one
    sql_on: ${athenadwh_clinical_letters_clone.clinical_provider_recipient_id} = ${athenadwh_letter_recipient_provider.clinical_provider_id} ;;
  }

#   join: athenadwh_orders_provider {
#     from: athenadwh_clinical_providers_clone
#     relationship:  many_to_one
#     sql_on: ${athenadwh_orders.clinical_provider_id} = ${athenadwh_orders_provider.clinical_provider_id} ;;
#   }
#
#   join: athenadwh_clinical_results_provider {
#     from: athenadwh_clinical_providers_clone
#     relationship:  many_to_one
#     sql_on: ${athenadwh_clinical_results_clone.clinical_provider_id} = ${athenadwh_clinical_results_provider.clinical_provider_id} ;;
#   }

  join: athenadwh_patients_clone {
    relationship: many_to_one
    sql_on: ${athenadwh_clinical_encounters_clone.patient_id} = ${athenadwh_patients_clone.patient_id} ;;
  }

  join: athenadwh_procedure_codes_clone {
    relationship: one_to_one
    sql_on: ${cpt_code_dimensions_clone.cpt_code} = ${athenadwh_procedure_codes_clone.procedure_code} AND
      ${athenadwh_procedure_codes_clone.deleted_datetime_raw} IS NULL ;;
  }

  join: athenadwh_transactions_clone {
    relationship: one_to_many
    sql_on: ${athenadwh_claims_clone.claim_id} = ${athenadwh_transactions_clone.claim_id} ;;
  }

  join: athenadwh_social_history_clone {
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.patient_id} = ${athenadwh_social_history_clone.patient_id} ;;
  }

  join: athenadwh_medical_history_clone {
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.chart_id} = ${athenadwh_medical_history_clone.chart_id} ;;
  }

# End Athena data warehouse tables

  # Join all cloned tables from the BI database -- DE,
  join: visit_facts_clone {
    view_label: "Visit Facts relevant ID's used for matching"
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${visit_facts_clone.care_request_id} ;;
  }

  join: visit_dimensions_clone {
    relationship: many_to_one
    sql_on: ${care_requests.id} = ${visit_dimensions_clone.care_request_id} ;;
  }

  join: transaction_facts_clone {
    relationship: one_to_many
    sql_on: ${transaction_facts_clone.visit_dim_number} = ${visit_dimensions_clone.visit_number}
    AND transaction_facts_clone.voided_date IS NULL ;;
  }

#   join: charge_dimensions_clone {
#     relationship: one_to_one
#     sql_on: ${transaction_facts_clone.athena_charge_id} = ${charge_dimensions_clone.athena_charge_id} ;;
#   }

  join: cpt_code_dimensions_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.cpt_code_dim_id} = ${cpt_code_dimensions_clone.id} ;;
  }

  join: cpt_code_types_clone {
    relationship: one_to_one
    sql_on: ${cpt_code_types_clone.cpt_code} = ${cpt_code_dimensions_clone.cpt_code} ;;
  }

# Not much information here -- unclear if this is necessary
#   join: cpt_em_references_clone {
#      relationship: one_to_one
#     sql_on: ${cpt_em_references_clone.cpt_code} = ${cpt_code_dimensions_clone.cpt_code} ;;
#   }

  join: icd_visit_joins_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.visit_dim_number} = ${icd_visit_joins_clone.visit_dim_number} ;;
  }

  join: icd_code_dimensions_clone {
    relationship: many_to_one
    sql_on: ${icd_code_dimensions_clone.id} = CAST(${icd_visit_joins_clone.icd_dim_id} AS INT) ;;
  }

  join: letter_recipient_dimensions_clone {
    relationship:  many_to_one
    sql_on: ${letter_recipient_dimensions_clone.id} = ${visit_facts_clone.letter_recipient_dim_id} ;;
  }

  join: market_projections_by_month {
    relationship: one_to_one
    sql_on: ${markets.name_adj} = ${market_projections_by_month.market} AND ${care_request_flat.complete_date} = ${market_projections_by_month.month_date} ;;
  }

  join: payer_dimensions_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.primary_payer_dim_id} = ${primary_payer_dimensions_clone.id}  ;;
  }

  join: primary_payer_dimensions_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.primary_payer_dim_id} = ${primary_payer_dimensions_clone.id} ;;
    # AND ${transaction_facts_clone.voided_date} IS NULL ;;
  }

  join: care_request_toc_predictions {
    relationship: one_to_one
    sql_on: ${care_request_toc_predictions.care_request_id} = ${care_requests.id} ;;
  }

  join: toc_predictions {
    relationship: one_to_many
    sql_on: ${toc_predictions.id} = ${care_request_toc_predictions.toc_prediction_id} ;;
  }

#   join: pcp_dimensions_clone {
#   sql_on: ??? ;;
#   }

#   join: shift_planning_facts_clone {
#     sql_on: ${shift_planning_facts_clone.car_dim_id} = ${visit_facts_clone.car_dim_id} ;;
#   }

  join: app_shift_planning_facts_clone {
    view_label: "APP Shift Information"
    from: shift_planning_facts_clone
    type: full_outer
    relationship: many_to_one
    sql_on: TRIM(UPPER(${app_shift_planning_facts_clone.clean_employee_name})) =
            replace(upper(trim(regexp_replace(replace(trim(${users.first_name}),'"',''), '^.* ', '')) || ' ' || trim(${users.last_name})), '''', '') AND
            ${app_shift_planning_facts_clone.local_actual_start_date} = ${visit_dimensions_clone.local_visit_date} ;;
    sql_where: ${app_shift_planning_facts_clone.schedule_role} LIKE '%Training%' OR
               ${app_shift_planning_facts_clone.schedule_role} LIKE '%NP/PA%' OR
               ${care_requests.id} IS NOT NULL ;;
  }

  join: dhmt_shift_planning_facts_clone {
    view_label: "DHMT Shift Information"
    from: shift_planning_facts_clone
    type: full_outer
    relationship: many_to_one
    sql_on: TRIM(UPPER(${dhmt_shift_planning_facts_clone.clean_employee_name})) =
            replace(upper(trim(regexp_replace(replace(${users.first_name},'"',''), '^.* ', '')) || ' ' || trim(${users.last_name})), '''', '') AND
            ${dhmt_shift_planning_facts_clone.local_actual_start_date} = ${visit_dimensions_clone.local_visit_date} AND
            ${dhmt_shift_planning_facts_clone.schedule_role} IN ('DHMT', 'EMT') AND
            ${dhmt_shift_planning_facts_clone.car_dim_id} IS NOT NULL ;;
  }

  join: survey_responses_flat_clone {
    relationship: one_to_one
    sql_on: ${survey_responses_flat_clone.visit_dim_number} = ${visit_facts_clone.visit_dim_number};;
  }

  # End cloned BI table joins
  ############################

  join: addressable_items {
    relationship: one_to_one
    sql_on: ${addressable_items.addressable_type} = 'CareRequest' and ${care_requests.id} = ${addressable_items.addressable_id};;
  }
  join: addresses {
    relationship: one_to_one
    sql_on:  ${addressable_items.address_id} = ${addresses.id} ;;
  }

  join: postal_codes {
    relationship: many_to_one
    sql_on: ${addresses.zipcode_short} = ${postal_codes.postalcode} ;;
  }

  join: credit_cards {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${credit_cards.care_request_id} ;;
  }

  join: care_request_network_referrals {
    relationship: one_to_many
    sql_on: ${care_request_network_referrals.care_request_id} = ${care_requests.id} ;;
  }

  join: network_referrals {
    relationship: one_to_one
    sql_on: ${network_referrals.id} = ${care_request_network_referrals.network_referral_id} ;;
  }

  join: care_request_distances {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${care_request_distances.care_request_id} ;;
  }

  join: care_request_consents {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${care_request_consents.care_request_id} ;;
  }

  join: care_team_members {
    relationship: one_to_many
    sql_on: ${care_requests.id} = ${care_team_members.care_request_id} ;;
  }

  join: credit_card_errors {
    relationship: one_to_many
    sql_on: ${care_requests.id} = ${credit_card_errors.care_request_id} ;;
  }

  join: shift_teams {
    relationship: many_to_one
    sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  }

  join: shift_team_members {
    relationship: many_to_one
    sql_on: ${shift_team_members.shift_team_id} = ${shift_teams.id} ;;
  }

  join: geo_locations {
    relationship: one_to_many
    sql_on: ${shift_teams.car_id} = ${geo_locations.car_id} AND ${shift_teams.start_date} = ${geo_locations.created_date} ;;
  }

  join: shifts{
    relationship: many_to_one
    sql_on:  ${shift_teams.shift_id}  =  ${shifts.id};;
  }

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_teams.car_id} = ${cars.id} ;;
  }

  join: users {
    relationship: one_to_one
    sql_on:  ${shift_team_members.user_id} = ${users.id};;
  }

  join: csc_user_roles {
    relationship: one_to_many
    from: user_roles
    sql_on: ${bill_processors.user_id} = ${csc_user_roles.user_id} ;;
  }

  join: csc_users {
    relationship: one_to_one
    from: roles
    sql_on: ${csc_user_roles.role_id} = ${csc_users.id} ;;
  }

  join: bill_processors {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${bill_processors.care_request_id} ;;
  }

  join: csc_names {
    relationship: one_to_many
    from: users
    sql_on: ${bill_processors.user_id} = ${csc_names.id} ;;
  }

  join: provider_profiles {
    relationship: one_to_one
    sql_on: ${provider_profiles.user_id} = ${users.id} ;;
  }

  join: provider_licenses {
    relationship: one_to_many
    sql_on: ${provider_profiles.id} = ${provider_licenses.provider_profile_id} ;;
  }

  join: dhmt_names {
    view_label: "DHMT Names"
    from: users
    relationship: one_to_one
    sql_on: ${users.id} = ${provider_profiles.user_id} AND ${provider_profiles.position} = 'emt' ;;
  }

  join: app_names {
    view_label: "Advanced Practice Provider Names"
    from: users
    relationship: one_to_one
    sql_on: ${users.id} = ${provider_profiles.user_id} AND ${provider_profiles.position} = 'advanced practice provider' ;;
  }

  join: risk_assessments {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${risk_assessments.care_request_id} and ${risk_assessments.score} is not null ;;
  }

  join: csc_created {
    from: users
    relationship: one_to_one
    sql_on:  ${care_request_requested.user_id} = ${csc_created.id} and lower(${care_requests.request_type}) ='phone';;
  }

  join: secondary_screening_provider {
    from: users
    relationship: one_to_one
    sql_on:  ${secondary_screenings.provider_id} = ${secondary_screening_provider.id};;
  }


  join: csc_risk_assessments {
    from: users
    relationship: one_to_one
    sql_on:  ${risk_assessments.user_id} = ${csc_risk_assessments.id};;
  }
  join: secondary_screenings {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${secondary_screenings.care_request_id} ;;
  }

  join: csc_agent_location_risk {
    from: csc_agent_location
    sql_on: ${csc_risk_assessments.csc_name} = ${csc_agent_location_risk.agent_name} ;;
  }

  join: csc_agent_location_created {
    from: csc_agent_location
    sql_on: ${csc_created.csc_name} = ${csc_agent_location_created.agent_name} ;;
  }




  join: markets {
    relationship: many_to_one
    sql_on: ${care_requests.market_id} = ${markets.id} ;;
  }
  join: market_start_date{
    sql_on: ${markets.id}=${market_start_date.market_id} ;;
  }

  join: states {
    relationship: one_to_one
    sql_on: ${markets.state} = ${states.abbreviation} ;;
  }

  join: insurances {
    relationship: many_to_one
    sql_on: ${care_requests.patient_id} = ${insurances.patient_id} AND ${insurances.priority} = '1' AND ${insurances.patient_id} IS NOT NULL ;;
  }

  join: insurance_plans {
    relationship: many_to_one
    sql_on: ${insurances.package_id} = ${insurance_plans.package_id} AND ${insurances.company_name} = ${insurance_plans.name} AND ${insurance_plans.state_id} = ${states.id};;
  }

  join: insurance_classifications {
    relationship: many_to_one
    sql_on: ${insurance_plans.insurance_classification_id} = ${insurance_classifications.id} ;;
  }

  join: care_request_complete{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_complete.care_request_id} = ${care_requests.id} and ${care_request_complete.name}='complete';;
  }

  join: care_request_requested{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_requested.care_request_id} = ${care_requests.id} and ${care_request_requested.name}='requested';;
  }

  join: care_request_accepted{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_accepted.care_request_id} = ${care_requests.id} and ${care_request_accepted.name}='accepted';;
  }

  join: care_request_archived{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='archived';;
  }

  join: care_request_scheduled{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_scheduled.care_request_id} = ${care_requests.id} and ${care_request_scheduled.name}='scheduled';;
  }

  join: care_request_flat {
    relationship: one_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }

  join: seasonal_adj {
    sql_on: ${care_request_flat.on_scene_month_num}=${seasonal_adj.month_number} ;;
  }

  join: days_in_month_adj {
    sql_on: ${care_request_flat.on_scene_month_num}=${days_in_month_adj.month_number} ;;
  }


  join: google_trend_data {
    sql_on: ${care_request_flat.on_scene_month_num} = ${google_trend_data.month}
            and
            ${markets.name_adj} = ${google_trend_data.market};;
  }

  join: dtc_categorization {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${dtc_categorization.care_request_id} ;;
  }

  join: timezones {
    relationship: many_to_one
    sql_on: ${timezones.rails_tz} = ${markets.sa_time_zone} ;;
  }

  join: budget_projections_by_market_clone {
    sql_on: ${markets.id_adj} = ${budget_projections_by_market_clone.market_dim_id}
      AND ${care_request_flat.on_scene_month}=${budget_projections_by_market_clone.month_month};;
  }

  join: patients {
    relationship: many_to_one
    sql_on:  ${care_requests.patient_id} = ${patients.id} ;;
  }

  join: driver_licenses {
    relationship: one_to_one
    sql_on: ${patients.id} = ${driver_licenses.patient_id} ;;
  }

  join: dtc_ff_patients {
    sql_on: ${patients.id} = ${dtc_ff_patients.patient_id} ;;
  }

  join: eligible_patients {
    relationship: one_to_one
    sql_on:
    UPPER(concat(${eligible_patients.first_name}::text, ${eligible_patients.last_name}::text, to_char(${eligible_patients.dob_raw}, 'MM/DD/YY'), ${eligible_patients.gender}::text)) =
    UPPER(concat(${patients.first_name}::text, ${patients.last_name}::text, to_char(${patients.dob}, 'MM/DD/YY'),
      CASE WHEN ${patients.gender} = 'Female' THEN 'F'
      WHEN ${patients.gender} = 'Male' THEN 'M'
      ELSE ''
      END)) ;;
  }

  join: power_of_attorneys {
    sql_on:  ${patients.id} =${power_of_attorneys.patient_id} ;;
  }

  join: channel_items {
    relationship: many_to_one
    sql_on:  ${care_requests.channel_item_id} = ${channel_items.id} ;;
  }

  join: patient_payer_lookup{
    relationship: one_to_one
    sql_on: ${patients.id} = ${patient_payer_lookup.dashboard_patient_id}  ;;
  }

  join: primary_payer_packages {
    relationship: one_to_many
    sql_on: ${patient_payer_lookup.primary_payer_dim_id} = ${primary_payer_packages.primary_payer_dim_id} ;;
  }

join: invoca_clone {
sql_on: ((${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null)
        OR (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null)
        )
        and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
        ;;

}
join: ga_pageviews_clone {
  sql_on:
    abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_mst_raw})) < (60*60*1.5)
          and ${ga_pageviews_clone.client_id} = ${invoca_clone.analytics_vistor_id}  ;;

  }

  join: web_ga_pageviews_clone {
    from: ga_pageviews_clone
    sql_on:
    abs(EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})-EXTRACT(EPOCH FROM ${web_ga_pageviews_clone.timestamp_mst_raw})) < (60*60*1.5)
      and care_requests.marketing_meta_data->>'ga_client_id' = ${web_ga_pageviews_clone.client_id}  ;;

    }

  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
             and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                  ;;
  }
  join: ga_experiments {
    sql_on: ${ga_pageviews_clone.exp_id} = ${ga_experiments.exp_id}
            OR
            ${web_ga_pageviews_clone.exp_id} = ${ga_experiments.exp_id} ;;
  }

  join: ga_adwords_stats_clone {
    sql_on: (${ga_adwords_stats_clone.client_id} = ${ga_pageviews_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_clone.timestamp_raw})
      OR (${ga_adwords_stats_clone.client_id} = ${web_ga_pageviews_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${web_ga_pageviews_clone.timestamp_raw});;
  }

  join: adwords_campaigns_clone {
    sql_on: ${adwords_campaigns_clone.campaign_id} = ${ga_adwords_stats_clone.adwordscampaignid}  ;;
  }

  join: ad_groups_clone {
    sql_on:  ${ga_adwords_stats_clone.adwordsadgroupid} = ${ad_groups_clone.adwordsadgroupid} ;;
  }
  join: shift_hours_by_day_market_clone {
    sql_on:  ${markets.name} = ${shift_hours_by_day_market_clone.market_name}
      and ${care_request_flat.complete_date} = ${shift_hours_by_day_market_clone.date_date};;
  }

  join: shift_hours_market_month {
    from: shift_hours_by_day_market_clone
    sql_on:  ${markets.name} = ${shift_hours_market_month.market_name}
      and ${care_request_flat.complete_month} = ${shift_hours_market_month.date_month};;
  }

  join: ga_adwords_cost_clone {
    sql_on:   ${ga_adwords_stats_clone.adwordscampaignid} =${ga_adwords_cost_clone.adwordscampaignid}
            and ${ga_adwords_stats_clone.adwordscreativeid} =${ga_adwords_cost_clone.adwordscreativeid}
            and ${ga_adwords_stats_clone.keyword} =${ga_adwords_cost_clone.keyword}
            and ${ga_adwords_stats_clone.adwordsadgroupid} =${ga_adwords_cost_clone.adwordsadgroupid}
                  and ${ga_adwords_stats_clone.page_timestamp_date} =${ga_adwords_cost_clone.date_date}

            ;;
  }
  join: marketing_cost_clone {
    type: full_outer
    sql_on:   lower(${ga_pageviews_clone.source_final}) = lower(${marketing_cost_clone.type})
              and ${ga_pageviews_clone.timestamp_mst_date} =${marketing_cost_clone.date_date}
              and lower(${ga_pageviews_clone.medium_final})  in('cpc', 'paid search', 'paidsocial', 'ctr', 'image_carousel', 'static_image', 'display', 'nativedisplay')
              and lower(${ga_pageviews_clone.ad_group_final}) = lower(${marketing_cost_clone.ad_group_name})
            and lower(${ga_pageviews_clone.campaign_final}) = lower(${marketing_cost_clone.campaign_name})

            ;;
  }

  join: subtotals_clone {
    type: cross
    relationship: one_to_many
  }

  join: subtotal_over_level2 {
    from: subtotals_clone
    type: cross
    relationship: one_to_many
    #when adding a level of nested subtotals, need to add this sql_where to exclude the generated row which would subtotal over the higher level, but not over this lower level.
    sql_where: not (${subtotals_clone.row_type_description}='SUBTOTAL' and not ${subtotal_over_level2.row_type_description}='SUBTOTAL') ;;
  }

  join: ed_diversion_survey_response_rate_clone {
    relationship: many_to_one
    sql_on: ${ed_diversion_survey_response_rate_clone.market_dim_id} = ${visit_facts_clone.market_dim_id} ;;
  }

  join: ed_diversion_survey_response_clone {
    relationship: many_to_one
    sql_on: ${ed_diversion_survey_response_clone.care_request_id} = ${visit_facts_clone.care_request_id} ;;
  }
}

explore: shift_planning_facts_clone {
  #view_label: "Shift Information"

  join: shift_planning_shifts_clone {
    relationship: one_to_one
    sql_on:  ${shift_planning_facts_clone.shift_id}=${shift_planning_shifts_clone.shift_id} and ${shift_planning_shifts_clone.imported_after_shift} = 1 ;;
  }

  join: markets {
    relationship: many_to_one
    sql_on: ${shift_planning_facts_clone.schedule_location_id} = ${markets.humanity_id} ;;
  }

  join: subtotal_markets {
    type: cross
    relationship: one_to_many
  }

  join: users {
    relationship: many_to_one
    sql_on: TRIM(UPPER(${shift_planning_facts_clone.clean_employee_name})) =
            replace(upper(trim(regexp_replace(replace(trim(${users.first_name}),'"',''), '^.* ', '')) || ' ' || trim(${users.last_name})), '''', '') ;;
  }

  # join: care_request_flat {
  #   sql_on: ${markets.id} = ${care_request_flat.market_id} AND  ;;
  # }

  # join: app_shift_planning_facts_clone {
  #   view_label: "APP Shift Information"
  #   from: shift_planning_facts_clone
  #   type: full_outer
  #   relationship: many_to_one
  #   sql_on: TRIM(UPPER(${app_shift_planning_facts_clone.clean_employee_name})) =
  #           replace(upper(trim(regexp_replace(replace(trim(${users.first_name}),'"',''), '^.* ', '')) || ' ' || trim(${users.last_name})), '''', '') AND
  #           ${app_shift_planning_facts_clone.local_actual_start_date} = ${visit_dimensions_clone.local_visit_date} ;;
  #   sql_where: ${app_shift_planning_facts_clone.schedule_role} LIKE '%Training%' OR
  #             ${app_shift_planning_facts_clone.schedule_role} LIKE '%NP/PA%' OR
  #             ${care_requests.id} IS NOT NULL ;;
  # }

}

explore: care_request_3day_bb {
  from: care_request_statuses
  sql_always_where: ${care_request_3day_bb.name} = 'followup_3' AND ${care_request_3day_bb.commentor_id} IS NOT NULL ;;

  join: care_requests {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${care_request_3day_bb.care_request_id} ;;
  }

  join: users{
    relationship: one_to_many
    sql_on: ${users.id} = ${care_request_3day_bb.commentor_id};;
  }

  join: markets {
    relationship: one_to_many
    sql_on: ${markets.id} = ${care_requests.market_id} ;;
  }

  join: timezones {
    relationship: one_to_one
    sql_on: ${timezones.rails_tz} = ${markets.sa_time_zone} ;;
  }

}

# explore: shift_planning_facts_clone {
#   # view_label: "Shifts and Visits"

#   join: shift_planning_shifts_clone {
#     relationship: one_to_one
#     sql_on:  ${shift_planning_facts_clone.shift_id}=${shift_planning_shifts_clone.shift_id} and ${shift_planning_shifts_clone.imported_after_shift} = 1 ;;
#   }

#   join: shift_team_visits {
#     relationship: one_to_many
#     sql_on: TRIM(UPPER(${shift_planning_facts_clone.clean_employee_name})) =
#     replace(upper(trim(regexp_replace(replace(trim(${shift_team_visits.first_name}),'"',''), '^.* ', '')) || ' ' || trim(${shift_team_visits.last_name})), '''', '') AND
#     ${shift_planning_facts_clone.local_actual_start_date}= ${shift_team_visits.complete_date_date};;
#   }

#   join: care_request_flat {
#     relationship: one_to_many
#     sql_on: ${care_request_flat.care_request_id} = ${shift_team_visits.care_request_id};;
#   }

#   join: care_requests {
#     relationship: one_to_many
#     sql_on: ${care_requests.id} = ${shift_team_visits.care_request_id} ;;
#   }

#   join: user_roles {
#     relationship: one_to_many
#     sql_on: ${user_roles.user_id} = ${shift_team_visits.user_id} ;;
#   }

#   join: roles {
#     relationship: one_to_one
#     sql_on: ${roles.id} = ${user_roles.role_id} ;;
#   }

#   join: provider_profiles {
#     relationship: one_to_one
#     sql_on: ${provider_profiles.user_id} = ${shift_team_visits.user_id} ;;
#   }

# }

explore: productivity_data_clone {

  join: market_market_dim_crosswalk {
    relationship: many_to_one
    sql_on: ${productivity_data_clone.market_dim_id} = ${market_market_dim_crosswalk.market_dim_id} ;;
  }

  join: markets {
    relationship: one_to_one
    sql_on: ${market_market_dim_crosswalk.market_id} = ${markets.id} ;;
    }

  join: shift_planning_facts_clone {
    relationship: one_to_many
    sql_on: ${productivity_data_clone.date_date} = ${shift_planning_facts_clone.local_actual_start_date} AND
            ${markets.humanity_id} = ${shift_planning_facts_clone.schedule_location_id} ;;
  }

  join: shift_planning_shifts_clone {
    relationship: one_to_one
    sql_on:  ${shift_planning_facts_clone.shift_id}=${shift_planning_shifts_clone.shift_id} and ${shift_planning_shifts_clone.imported_after_shift}=1 ;;
  }

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_planning_facts_clone.car_dim_id} = ${cars.id} ;;
  }

  # join: timezones {
  #   relationship: many_to_one
  #   sql: ${timezones.rails_tz} = ${markets.sa_time_zone} ;;
  # }

  join: shift_teams {
    relationship: one_to_one
    sql_on: ${shift_teams.car_id} = ${shift_planning_facts_clone.car_dim_id} AND
            ${shift_planning_facts_clone.local_actual_start_date} = (${shift_teams.start_date}- INTERVAL '6 hour') ;;
  }

  join: shifts{
    relationship: one_to_one
    sql_on:  ${shift_teams.shift_id}  =  ${shifts.id};;
  }

  join: users {
    relationship: one_to_many
    sql_on: TRIM(UPPER(${shift_planning_facts_clone.clean_employee_name})) =
            replace(upper(trim(regexp_replace(replace(trim(${users.first_name}),'"',''), '^.* ', '')) || ' ' || trim(${users.last_name})), '''', '') AND
            ${shift_planning_facts_clone.local_actual_start_date} = ${productivity_data_clone.date_date} ;;
  }

  join: shift_team_members {
    relationship: one_to_many
    sql_on: ${shift_team_members.user_id} = ${users.id} ;;
  }

  join: care_requests {
    relationship: many_to_one
    sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  }

  join: care_request_flat {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${care_request_flat.care_request_id} ;;
  }

}

explore: channel_items {
  join: care_requests {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: care_request_flat {
    relationship: many_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }

  join: channels {
    relationship: many_to_one
    sql_on:  ${channels.id} = ${channel_items.channel_id};;
  }

  join: sales_force_implementation_score_recent {
    type: full_outer
    relationship: one_to_one
    sql_on: ${sales_force_implementation_score_recent.channel_item_id} = ${channel_items.id} ;;
  }

  join: sales_force_implementation_score_one_week {
    from: sales_force_implementation_score_clone
    sql_on: ${sales_force_implementation_score_one_week.sf_account_name} = ${sales_force_implementation_score_recent.sf_account_name}
   and  ${sales_force_implementation_score_one_week.sf_implementation_name} = ${sales_force_implementation_score_recent.sf_implementation_name}
    and ${sales_force_implementation_score_one_week.created_date}=current_date - interval '7 day';;
  }

  join: sales_force_implementation_score_one_month {
    from: sales_force_implementation_score_clone
    sql_on: ${sales_force_implementation_score_one_month.sf_account_name} = ${sales_force_implementation_score_recent.sf_account_name}
        and  ${sales_force_implementation_score_one_month.sf_implementation_name} = ${sales_force_implementation_score_recent.sf_implementation_name}
          and ${sales_force_implementation_score_one_month.created_date}=current_date - interval '30 day';;
  }

  join: markets {
    relationship: many_to_one
    sql_on: ${sales_force_implementation_score_recent.market_id_final} = ${markets.id} ;;
  }

}

explore: invoca_clone {


  join: incontact_clone {
    type: full_outer
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
             and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                  ;;
    sql_where: (${invoca_clone.utm_medium} !='self report' or ${incontact_clone.contact_id} is not null) ;;
  }

  join: patients {
    sql_on:   (
                ${patients.mobile_number} = ${invoca_clone.caller_id} OR
                ${patients.mobile_number} = ${incontact_clone.from_number}
              )
             and ${patients.mobile_number} is not null   ;;
  }

  join: care_requests {
    sql_on: (${patients.id} = ${care_requests.patient_id}  OR ${care_requests.origin_phone} = ${invoca_clone.caller_id} or ${care_requests.origin_phone} = ${incontact_clone.from_number})
      and (
            abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
            OR
           abs(EXTRACT(EPOCH FROM ${incontact_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
          );;
  }

  join: care_request_flat {
    relationship: many_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }


  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: markets {
    sql_on:  ${markets.id} =${invoca_clone.market_id} ;;
  }

  join: ga_pageviews_clone {
    sql_on:
    ${invoca_clone.analytics_vistor_id} = ${ga_pageviews_clone.client_id}
  and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_mst_raw})) < (60*60*1.5)
    ;;
  }

  join: ga_experiments {
    sql_on: ${ga_pageviews_clone.exp_id} = ${ga_experiments.exp_id};;

  }


  join: ga_adwords_stats_clone {
    sql_on:
    ${ga_adwords_stats_clone.client_id} = ${ga_pageviews_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_clone.timestamp_raw};;
  }

  join: ga_adwords_cost_clone {
    sql_on:   ${ga_adwords_stats_clone.adwordscampaignid} =${ga_adwords_cost_clone.adwordscampaignid}
            and ${ga_adwords_stats_clone.adwordscreativeid} =${ga_adwords_cost_clone.adwordscreativeid}
            and ${ga_adwords_stats_clone.keyword} =${ga_adwords_cost_clone.keyword}
            and ${ga_adwords_stats_clone.adwordsadgroupid} =${ga_adwords_cost_clone.adwordsadgroupid}
                  and ${ga_adwords_stats_clone.page_timestamp_date} =${ga_adwords_cost_clone.date_date}
            ;;
  }


  join: adwords_campaigns_clone {
    sql_on: ${adwords_campaigns_clone.campaign_id} = ${ga_adwords_stats_clone.adwordscampaignid}  ;;
  }

  join: adwords_ad_clone {
    sql_on:  ${ga_adwords_stats_clone.adwordscreativeid} = ${adwords_ad_clone.ad_id} ;;
  }

  join: ad_groups_clone {
    sql_on:  ${ga_adwords_stats_clone.adwordsadgroupid} = ${ad_groups_clone.adwordsadgroupid} ;;
  }
  join: marketing_cost_clone {
    type: full_outer
    sql_on:   lower(${ga_pageviews_clone.source_final}) = lower(${marketing_cost_clone.type})
              and ${ga_pageviews_clone.timestamp_mst_date} =${marketing_cost_clone.date_date}
              and lower(${ga_pageviews_clone.medium_final})  in('cpc', 'paid search', 'paidsocial', 'ctr', 'image_carousel', 'static_image', 'display', 'nativedisplay')
              and lower(${ga_pageviews_clone.ad_group_final}) = lower(${marketing_cost_clone.ad_group_name})
            and lower(${ga_pageviews_clone.campaign_final}) = lower(${marketing_cost_clone.campaign_name})

            ;;
  }





}

explore: ga_pageviews_full_clone {
  label: "GA explore"


  join: invoca_clone {
    type:  full_outer
    sql_on:
    abs(
        EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_full_clone.timestamp_mst_raw})) < (60*60*1.5)
          and ${ga_pageviews_full_clone.client_id} = ${invoca_clone.analytics_vistor_id}  ;;

  }

  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
             and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                  ;;
  }

  join: ga_experiments {
    sql_on: ${ga_pageviews_full_clone.exp_id} = ${ga_experiments.exp_id};;

  }

  join: ga_adwords_stats_clone {
    sql_on: ${ga_adwords_stats_clone.client_id} = ${ga_pageviews_full_clone.client_id}
      and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_full_clone.timestamp_raw};;
  }

  join: adwords_campaigns_clone {
    sql_on: ${adwords_campaigns_clone.campaign_id} = ${ga_adwords_stats_clone.adwordscampaignid}  ;;
  }

  join: ad_groups_clone {
    sql_on:  ${ga_adwords_stats_clone.adwordsadgroupid} = ${ad_groups_clone.adwordsadgroupid} ;;
  }


  join: patients {
    sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
  }



  join: ga_geodata_clone {
    sql_on: ${ga_pageviews_full_clone.client_id} = ${ga_geodata_clone.client_id}
    and ${ga_pageviews_full_clone.timestamp_raw} = ${ga_geodata_clone.timestamp_raw};;
  }

  join: ga_zips_clone {
    sql_on: ${ga_geodata_clone.latitude} = ${ga_zips_clone.latitude}
      and  ${ga_geodata_clone.longitude} = ${ga_zips_clone.longitude};;
  }


  join: web_care_requests {
    from: care_requests
    sql_on:
        (
          abs(EXTRACT(EPOCH FROM ${ga_pageviews_full_clone.timestamp_mst_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
          AND
          web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_full_clone.client_id}
         ) ;;
  }

  join: care_requests {
    sql_on:
        (
          (
            ${patients.id} = ${care_requests.patient_id} and  (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
          OR
          (
            ${care_requests.origin_phone} = ${invoca_clone.caller_id}
            and
            ${care_requests.origin_phone} is not null
          )
        )
        AND
        abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
        );;
  }

  join: dtc_ff_patients {
    sql_on: ${patients.id} = ${care_requests.patient_id}
         OR ${patients.id} = ${web_care_requests.patient_id} ;;
  }



  join: care_request_flat {
    relationship: many_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }

  join: web_care_request_flat {
    from: care_request_flat
    relationship: many_to_one
    sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
  }



  join: markets {
    sql_on:  ${markets.id} = ${ga_pageviews_full_clone.market_id} ;;
  }


  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} or ${channel_items.id} =${web_care_requests.channel_item_id};;
  }

  join: dtc_categorization {
    relationship: one_to_one
    sql_on: ${dtc_categorization.care_request_id} =${care_requests.id} or ${dtc_categorization.care_request_id} =${web_care_requests.id};;
  }

  join: marketing_cost_clone {
    type: full_outer
    sql_on:   lower(${ga_pageviews_full_clone.source_final}) = lower(${marketing_cost_clone.type})
    and ${ga_pageviews_full_clone.timestamp_mst_date} =${marketing_cost_clone.date_date}
    and lower(${ga_pageviews_full_clone.medium_final})  in('cpc', 'paid search', 'paidsocial', 'ctr', 'image_carousel', 'static_image', 'display', 'nativedisplay')
    and lower(${ga_pageviews_full_clone.ad_group_final}) = lower(${marketing_cost_clone.ad_group_name})
    and lower(${ga_pageviews_full_clone.campaign_final}) = lower(${marketing_cost_clone.campaign_name})

    ;;
    sql_where:  ${invoca_clone.start_date} >'2018-03-15'
    OR ${ga_pageviews_full_clone.timestamp_time} is not null
    or ${marketing_cost_clone.date_date} is not null;;
  }


}

explore: ga_pageviews_clone {
  label: "Facebook Paid Explore"

  join: facebook_paid_performance_clone {
    type:  full_outer
    sql_on: ${facebook_paid_performance_clone.market_id} = ${ga_pageviews_clone.facebook_market_id_final}
        AND
        ${ga_pageviews_clone.timestamp_date} = ${facebook_paid_performance_clone.start_date}
        AND
        lower(${ga_pageviews_clone.source}) in ('facebook', 'facebook.com', 'instagram', 'instagram.com')
        AND
        lower(${ga_pageviews_clone.medium}) in('image_carousel', 'paidsocial', 'ctr', 'static_image');;
  }

  join: invoca_clone {
    type: full_outer
    sql_on:

    (
      abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_mst_raw})) < (60*60*1.5)
      and
      ${ga_pageviews_clone.client_id} = ${invoca_clone.analytics_vistor_id}
    )
     ;;

      sql_where:
              (
                (
                  ${invoca_clone.utm_medium} in('image_carousel', 'paidsocial', 'ctr', 'static_image')
                  AND
                  lower(${invoca_clone.utm_source}) in('facebook', 'facebook.com', 'instagram', 'instagram.com')
                )
                OR
                (
                  ${invoca_clone.utm_source} like '%FB Click to Call%'
                )
                AND
                ${invoca_clone.start_date} >'2018-03-15'
              )
              OR
              (
                lower(${ga_pageviews_clone.source}) in ('facebook', 'facebook.com', 'instagram', 'instagram.com')
                AND
                lower(${ga_pageviews_clone.medium}) in('image_carousel', 'paidsocial', 'ctr', 'static_image')
              )
              OR
              ${facebook_paid_performance_clone.start_date} is not null
              ;;
    }

    join: incontact_clone {
      sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
           and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                ;;
    }

    join: patients {
      sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
    }


    join: web_care_requests {
      from: care_requests
      sql_on:
      (
        abs(EXTRACT(EPOCH FROM ${ga_pageviews_clone.timestamp_mst_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
        AND
        web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_clone.client_id}
      ) ;;
    }

  join: care_requests {
    sql_on:
      (
        (
          ${patients.id} = ${care_requests.patient_id} and  (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
          OR
          (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
        )
        AND
        abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
      );;
  }


    join: care_request_flat {
      relationship: many_to_one
      sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
    }

    join: web_care_request_flat {
      from: care_request_flat
      relationship: many_to_one
      sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
    }

    join: markets {
      sql_on:  ${markets.id} = ${ga_pageviews_clone.facebook_market_id_final} ;;
    }


    join: channel_items {
      sql_on:  ${channel_items.id} =${care_requests.channel_item_id} OR
                ${channel_items.id} =${web_care_requests.channel_item_id} ;;
    }

  join: ga_experiments {
    sql_on: ${ga_pageviews_clone.exp_id} = ${ga_experiments.exp_id};;

  }

  }



  explore: ga_pageviews_bidellect {
    label: "Bidellect Explore"

    join: bidtellect_cost_clone {
      type:  full_outer
      sql_on: ${bidtellect_cost_clone.market_id} = ${ga_pageviews_bidellect.market_id}
        AND
        ${ga_pageviews_bidellect.timestamp_date} = ${bidtellect_cost_clone.hour_date}
        AND
        lower(${ga_pageviews_bidellect.source}) in ('bidtellect')
        AND
        lower(${ga_pageviews_bidellect.medium}) in('nativedisplay');;
    }

    join: invoca_clone {
      type: full_outer
      sql_on:

              (
                abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_pageviews_bidellect.timestamp_raw})) < (60*60*1.5)
                and
                ${ga_pageviews_bidellect.client_id} = ${invoca_clone.analytics_vistor_id}
              )
               ;;

        sql_where:
                (
                  (
                    lower(${invoca_clone.utm_source}) in('bidtellect')
                    AND
                    lower(${invoca_clone.utm_medium}) in('nativedisplay')
                  )
                  AND
                  ${invoca_clone.start_date} >'2018-03-15'
                )
                OR
                (
                  lower(${ga_pageviews_bidellect.source}) in ('bidtellect')
                  AND
                  lower(${ga_pageviews_bidellect.medium}) in('nativedisplay')
                )
                OR
                ${bidtellect_cost_clone.hour_date} is not null
                ;;
      }

      join: incontact_clone {
        sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
                 and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                      ;;
      }

      join: patients {
        sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
      }



      join: web_care_requests {
        from: care_requests
        sql_on:
            (
              abs(EXTRACT(EPOCH FROM ${ga_pageviews_bidellect.timestamp_mst_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
              AND
              web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_pageviews_bidellect.client_id}
            ) ;;
      }

    join: care_requests {
      sql_on:
            (
              (
                ${patients.id} = ${care_requests.patient_id} and (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
                OR
                (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
              )
              AND
              abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
            );;
    }
      join: care_request_flat {
        relationship: many_to_one
        sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
      }

      join: web_care_request_flat {
        from: care_request_flat
        relationship: many_to_one
        sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
      }

      join: markets {
        sql_on:  ${markets.id} = ${ga_pageviews_bidellect.market_id_final} ;;
      }

      join: channel_items {
        sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
      }
    }



    explore: ga_adwords_stats_clone {

      join: ga_adwords_cost_clone {
        type: full_outer
        sql_on:   ${ga_adwords_stats_clone.adwordscampaignid} =${ga_adwords_cost_clone.adwordscampaignid}
                and ${ga_adwords_stats_clone.adwordscreativeid} =${ga_adwords_cost_clone.adwordscreativeid}
                and ${ga_adwords_stats_clone.keyword} =${ga_adwords_cost_clone.keyword}
                and ${ga_adwords_stats_clone.adwordsadgroupid} =${ga_adwords_cost_clone.adwordsadgroupid}
                and ${ga_adwords_stats_clone.admatchtype} =${ga_adwords_cost_clone.admatchtype}
                      and ${ga_adwords_stats_clone.page_timestamp_date} =${ga_adwords_cost_clone.date_date}

                ;;
      }
      join: ga_pageviews_clone {
        sql_on: ${ga_adwords_stats_clone.client_id} = ${ga_pageviews_clone.client_id}
          and ${ga_adwords_stats_clone.page_timestamp_raw} = ${ga_pageviews_clone.timestamp_raw};;
      }

      join: adwords_campaigns_clone {
        sql_on: ${adwords_campaigns_clone.campaign_id} = ${ga_adwords_cost_clone.adwordscampaignid}  ;;
      }

      join: adwords_ad_clone {
        sql_on:  ${ga_adwords_cost_clone.adwordscreativeid} = ${adwords_ad_clone.ad_id} ;;
      }

      join: ad_groups_clone {
        sql_on:  ${ga_adwords_cost_clone.adwordsadgroupid} = ${ad_groups_clone.adwordsadgroupid} ;;
      }



      join: invoca_clone {
        type: full_outer
        sql_on:
                (
                  abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${ga_adwords_stats_clone.page_timestamp_raw})) < (60*60*1.5) and
                  ${ga_adwords_stats_clone.client_id} = ${invoca_clone.analytics_vistor_id}
                )
              ;;
        sql_where:(
            (
              (
                ${invoca_clone.utm_medium} in('paid search', 'cpc')
                AND
                ${invoca_clone.utm_source} in('google.com', 'google')
              )
              OR
              ${invoca_clone.utm_medium} in('Google Call Extension')
            )
            AND
            ${invoca_clone.start_date} >'2018-03-06'
          )
            OR
            ${ga_adwords_stats_clone.adwordscampaignid} != 0
            OR
             ${ga_adwords_cost_clone.adwordscampaignid} != 0
            ;;
      }

      join: incontact_clone {
        sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
                 and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                      ;;
      }

      join: patients {
        sql_on:  ${patients.mobile_number} = ${invoca_clone.caller_id} and ${patients.mobile_number} is not null  ;;
      }

      join: web_care_requests {
        from: care_requests
        sql_on:
              (

                 abs(EXTRACT(EPOCH FROM ${ga_adwords_stats_clone.page_timestamp_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
                AND
                web_care_requests.marketing_meta_data->>'ga_client_id' = ${ga_adwords_stats_clone.client_id}
              ) ;;

        }

      join: care_requests {
        sql_on:
            (
              (
                ${patients.id} = ${care_requests.patient_id} and (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
                OR
                (${care_requests.origin_phone} = ${invoca_clone.caller_id} and ${care_requests.origin_phone} is not null )
              )
              AND
              abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)

            );;

        }


          join: care_request_flat {
            relationship: many_to_one
            sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
          }

          join: web_care_request_flat {
            from: care_request_flat
            relationship: many_to_one
            sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
          }

          join: markets {
            sql_on:  ${markets.id} =${ga_adwords_stats_clone.market_id} ;;
          }


          join: channel_items {
            sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
          }

      join: web_channel_items {
        from: channel_items
        sql_on:  ${web_channel_items.id} =${web_care_requests.channel_item_id} ;;
      }


        }

        explore: zipcodes {
          join: markets {
            sql_on: ${zipcodes.market_id} = ${markets.id} ;;
          }
        }

        explore: insurance_plans {

          join: states{
            relationship: many_to_one
            sql_on:  ${states.id} =${insurance_plans.state_id} ;;
          }

          join: insurance_classifications {
            relationship: many_to_one
            sql_on: ${insurance_plans.insurance_classification_id} = ${insurance_classifications.id} ;;
          }
        }

  explore: incontact_clone {

          join: invoca_clone {
            sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 300
                     and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                          ;;
          }
          join: csc_agent_location {
            sql_on: ${csc_agent_location.agent_name} = ${incontact_clone.agent_name} ;;
          }

          join: patients {
            sql_on:   (
                ${patients.mobile_number} = ${incontact_clone.from_number}
              )
             and ${patients.mobile_number} is not null   ;;
          }

          join: care_requests {
            sql_on: ${care_requests.created_mountain_date} = ${incontact_clone.start_date} and ${incontact_clone.market_id} =${care_requests.market_id} ;;
          }
          join: care_request_flat {
            relationship: many_to_one
            sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
          }


          join: care_requests_exact {
            from: care_requests
            sql_on: (${patients.id} = ${care_requests_exact.patient_id}  OR ${care_requests_exact.origin_phone} = ${incontact_clone.from_number})
            and (
                   abs(EXTRACT(EPOCH FROM ${incontact_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests_exact.created_mountain_raw})) < (60*60*24)
            );;
            }

          join: care_request_flat_exact {
            from: care_request_flat
            relationship: many_to_one
            sql_on: ${care_request_flat_exact.care_request_id} = ${care_requests_exact.id} ;;
          }


          join: care_requests_contact_id {
            from: care_requests
            sql_on: ${care_requests_contact_id.contact_id} = ${incontact_clone.contact_id};;
          }

          join: care_request_flat_contact_id {
            from: care_request_flat
            relationship: many_to_one
            sql_on: ${care_request_flat_contact_id.care_request_id} = ${care_requests_contact_id.id} ;;
          }

          join: risk_assessments {
            relationship: one_to_one
            sql_on: ${care_requests_exact.id} = ${risk_assessments.care_request_id} and ${risk_assessments.score} is not null ;;
          }



          join: markets {
            sql_on:  ${markets.id} = ${incontact_clone.market_id} ;;
          }

          join: channel_items {
            sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
          }
          join: csc_working_rate_week_clone {
            sql_on: ${incontact_clone.agent_name} = ${csc_working_rate_week_clone.agent_name}
                     and
                     ${incontact_clone.start_week} = ${csc_working_rate_week_clone.week_week};;
          }

    join: csc_working_rate_month_clone {
      sql_on: ${incontact_clone.agent_name} = ${csc_working_rate_month_clone.agent_name}
                     and
                     ${incontact_clone.start_month} = ${csc_working_rate_month_clone.month_month};;
    }
          join: csc_survey_clone {
             sql_on: ${csc_survey_clone.contact_id} = ${incontact_clone.contact_id} and ${csc_survey_clone.active} ;;
          }


        }
explore: marketing_cost_clone {
  join: markets {
    sql_on: ${markets.id}=${marketing_cost_clone.market_id} ;;
  }

}

explore: cost_projections {
  join: markets {
    sql_on: ${markets.name}=${cost_projections.market} ;;
  }

  join: care_request_flat {
    relationship: many_to_one
    sql_on: ${care_request_flat.on_scene_month} = ${cost_projections.month_month} and ${markets.id} =${care_request_flat.market_id} ;;

  }
  join: care_requests {
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;

  }
  join: visit_facts_clone {
    sql_on: ${care_requests.id} = ${visit_facts_clone.care_request_id} ;;
  }


  join: patients {
    sql_on: ${patients.id}=${care_requests.patient_id} ;;
  }



}

        explore: csc_survey_clone {
          sql_always_where:  ${csc_survey_clone.active};;

          join: incontact_clone {
            sql_on:  ${incontact_clone.contact_id} = ${csc_survey_clone.contact_id} ;;
          }

          join: markets {
            sql_on: ${incontact_clone.market_id} = ${markets.id} ;;
          }


        }
  explore: phx_crime_zips {
    join:  zipcodes {
      sql_on: ${phx_crime_zips.zipcode}::text=${zipcodes.zip}::text ;;
    }
  }

explore: phx_crime_census {
  join:  census_zipcode {
    sql_on: ${phx_crime_census.census_tract}=${census_zipcode.census_tract};;
  }
  join:  zipcodes {
    sql_on: ${census_zipcode.zipcode}::text=${zipcodes.zip}::text ;;
  }
  join:  phx_crime_zips {
    sql_on: ${census_zipcode.zipcode}::text=${phx_crime_zips.zipcode}::text ;;
  }
  join: census_tract_clone {
    sql_on: ${census_tract_clone.census_tract}=${phx_crime_census.census_tract} ;;
  }

}
explore: uhc_ma_houston {

}

explore: shift_routes {

  join: markets {
    relationship: one_to_many
    sql_on: ${markets.id} = ${shift_routes.market_id} ;;
  }

  join: cars {
    relationship: one_to_many
    sql_on: ${cars.id} = ${shift_routes.car_id} ;;
  }

}

explore: brant_testing {}

explore:thpg_providers  {
  join: thpg_zipcode {
  sql_on: ${thpg_providers.zip} = ${thpg_zipcode.zipcodes} ;;
  }
}

explore:thpg_hospitals  {
  join: thpg_zipcode {
    sql_on: ${thpg_hospitals.zip_code} = ${thpg_zipcode.zipcodes} ;;
  }
}

explore:thpg_satellite_locations  {
  join: thpg_zipcode {
    sql_on: ${thpg_satellite_locations.satellite_zip} = ${thpg_zipcode.zipcodes} ;;
  }
}

explore:thpg_texashealth_backcare  {
  join: thpg_zipcode {
    sql_on: ${thpg_texashealth_backcare.zip} = ${thpg_zipcode.zipcodes} ;;
  }
}


explore:thpg_zipcode  {
}

explore: dates_hours_reference_clone {

  join: shift_teams {
    sql_on:  ${dates_hours_reference_clone.datehour_date} = ${shift_teams.start_mountain_date}
            AND ${dates_hours_reference_clone.datehour_hour_of_day} >= ${shift_teams.start_mountain_hour_of_day}
            AND ${dates_hours_reference_clone.datehour_hour_of_day} <= ${shift_teams.end_mountain_hour_of_day}
            and extract (epoch from (${shift_teams.end_mountain_raw}- ${shift_teams.start_mountain_raw}))::integer > 600
            ;;
  }

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_teams.car_id} = ${cars.id} ;;
  }

  join: markets {
    relationship: many_to_one
    sql_on: ${markets.id} = ${cars.market_id} ;;
  }

  join: timezones {
    relationship: many_to_one
    sql_on: ${timezones.rails_tz} = ${markets.sa_time_zone} ;;
  }



  join: care_request_flat {
    type: left_outer
    relationship: one_to_many
    sql_on:  (DATE(${care_request_flat.on_scene_mountain_date}) = ${dates_hours_reference_clone.datehour_date}
      AND ${care_request_flat.on_scene_mountain_hour_of_day} = ${dates_hours_reference_clone.hour_of_day}
      AND ${care_request_flat.shift_team_id} = ${shift_teams.id}) ;;
  }

  join: care_requests {
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }

}
explore: marketing_data_processed {
  join: patients {
    sql_on:  ${patients.mobile_number} = ${marketing_data_processed.invoca_phone_number} and ${patients.mobile_number} is not null  ;;
  }

  join: ga_geodata_clone {
    sql_on: ${marketing_data_processed.ga_client_id} = ${ga_geodata_clone.client_id}
      and ${marketing_data_processed.ga_timestamp_orig_raw} = ${ga_geodata_clone.timestamp_raw};;
  }


  join: web_care_requests {
    from: care_requests
    sql_on:
        (
          abs(EXTRACT(EPOCH FROM ${marketing_data_processed.ga_timestamp_mst_raw})-EXTRACT(EPOCH FROM ${web_care_requests.created_mountain_raw})) < (60*60*1.5)
          AND
          web_care_requests.marketing_meta_data->>'ga_client_id' = ${marketing_data_processed.ga_client_id}
         ) ;;
  }

  join: care_requests {
    sql_on:
        (
          (
            ${patients.id} = ${care_requests.patient_id} and  (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_requests.id})
          OR
          (
            ${care_requests.origin_phone} = ${marketing_data_processed.invoca_phone_number}
            and
            ${care_requests.origin_phone} is not null
          )
        )
        AND
        abs(EXTRACT(EPOCH FROM ${marketing_data_processed.invoca_start_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < (60*60*1.5)
        );;
  }

  join: dtc_ff_patients {
    sql_on: ${patients.id} = ${care_requests.patient_id}
      OR ${patients.id} = ${web_care_requests.patient_id} ;;
  }



  join: care_request_flat {
    relationship: many_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }

  join: web_care_request_flat {
    from: care_request_flat
    relationship: many_to_one
    sql_on: ${web_care_request_flat.care_request_id} = ${web_care_requests.id} ;;
  }



  join: markets {
    sql_on:  ${markets.id} = ${marketing_data_processed.market_id} ;;
  }


  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} or ${channel_items.id} =${web_care_requests.channel_item_id};;
  }

  join: dtc_categorization {
    relationship: one_to_one
    sql_on: ${dtc_categorization.care_request_id} =${care_requests.id} or ${dtc_categorization.care_request_id} =${web_care_requests.id};;
  }


}
explore: last_patient_seen {

}

explore: houston_zipcodes_processed{
  join: zipcodes {
    sql_on: ${zipcodes.zip}::int =${houston_zipcodes_processed.zipcode} and ${zipcodes.market_id}=165 ;;
  }
}
