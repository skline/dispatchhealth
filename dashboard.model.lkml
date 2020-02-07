connection: "dashboard"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

datagroup: care_request_datagroup {
  sql_trigger: SELECT max(id) FROM care_requests ;;
  max_cache_age: "6 hours"
}

explore: care_requests {

  persist_with: care_request_datagroup

  sql_always_where: ${deleted_raw} IS NULL AND
  (${care_request_flat.secondary_resolved_reason} NOT IN ('Test Case', 'Duplicate', 'Test') OR ${care_request_flat.secondary_resolved_reason} IS NULL)
  AND ${patients.last_name} NOT LIKE '%Test%' ;;

  access_filter: {
    field: markets.name
    user_attribute: "market_name"
  }


# Join all Athena data warehouse feed tables -- DE
  join: athenadwh_patient_insurances_clone {
    relationship: one_to_many
    sql_on: ${patients.ehr_id} = ${athenadwh_patient_insurances_clone.patient_id}::varchar
    AND ${athenadwh_patient_insurances_clone.cancellation_date} IS NULL
    AND (${athenadwh_patient_insurances_clone.sequence_number}::int = 1 OR ${athenadwh_patient_insurances_clone.insurance_package_id}::int = -100)
      /*AND ${athenadwh_patient_insurances_clone.insurance_package_id}::int != 0 */ ;;
  }

  join: athenadwh_patientinsurance_clone {
    relationship: one_to_many
    sql_on: ${patients.ehr_id} = ${athenadwh_patientinsurance_clone.patient_id}::varchar
          AND ${athenadwh_patientinsurance_clone.cancellation_date} IS NULL
          AND ${athenadwh_patientinsurance_clone.expiration_date} IS NULL
          AND ${athenadwh_patientinsurance_clone.insurance_package_id}::int <> 0
          AND (${athenadwh_patientinsurance_clone.sequence_number}::int = 1 OR ${athenadwh_patientinsurance_clone.insurance_package_id}::int = -100) ;;
  }

  join: athenadwh_payers_clone {
    relationship: many_to_one
    sql_on: ${athenadwh_patient_insurances_clone.insurance_package_id} = ${athenadwh_payers_clone.insurance_package_id} ;;
  }


  join: athenadwh_clinical_encounters_clone {
    relationship:  one_to_one
    sql_on: ${care_requests.ehr_id} = ${athenadwh_clinical_encounters_clone.appointment_id}::varchar;;
  }

  join: athenadwh_clinical_encounters_clone_full {
    relationship: one_to_one
    type: inner
    sql_on: ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_clinical_encounters_clone_full.clinical_encounter_id} AND
            ${athenadwh_clinical_encounters_clone.closed_datetime}::timestamp = ${athenadwh_clinical_encounters_clone_full.closed_datetime_raw}::timestamp ;;
  }

  join: athenadwh_chart_closing {
    #from: athenadwh_clinical_encounters_clone_full
    relationship: one_to_one
    sql_on: ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_chart_closing.clinical_encounter_id} ;;
    #AND ${athenadwh_clinical_encounters_clone.encounter_date}::date = ${athenadwh_chart_closing.encounter_date}::date ;;
  }

  join: athenadwh_patient_medication_listing {
    from: athenadwh_patient_medication_clone
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.patient_id} = ${athenadwh_patient_medication_listing.patient_id} AND
    ${athenadwh_clinical_encounters_clone.chart_id} = ${athenadwh_patient_medication_listing.chart_id} AND
    ${athenadwh_patient_medication_listing.medication_type} = 'PATIENTMEDICATION' ;;
  }

  join: athenadwh_patient_current_medication_listing {
    from: athenadwh_patient_current_medications
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.patient_id} = ${athenadwh_patient_current_medication_listing.patient_id} AND
          ${athenadwh_clinical_encounters_clone.chart_id} = ${athenadwh_patient_current_medication_listing.chart_id} ;;
  }

  join: athenadwh_patient_prescriptions {
    from: athenadwh_patient_medication_clone
    relationship: one_to_one
    sql_on: ${athenadwh_prescriptions.document_id} = ${athenadwh_patient_prescriptions.document_id} AND
          ${athenadwh_patient_prescriptions.medication_type} = 'CLINICALPRESCRIPTION' ;;
  }

  join: athenadwh_medication_clone {
    relationship: many_to_one
    sql_on: ${athenadwh_patient_current_medication_listing.medication_id} = ${athenadwh_medication_clone.medication_id} ;;
  }

  join: prescribed_medications  {
    from: athenadwh_medication_clone
    relationship: many_to_one
    sql_on: UPPER(${athenadwh_prescriptions.clinical_order_type}) = UPPER(${prescribed_medications.medication_name}) ;;
  }

  join: athenadwh_provider_clone {
    relationship: many_to_one
    sql_on: ${athenadwh_clinical_encounters_clone.provider_id} = ${athenadwh_provider_clone.provider_id} ;;
    #sql_where: ${athenadwh_provider_clone.provider_id} != ${athenadwh_provider_clone.supervising_provider_id} ;;
  }

  join: athenadwh_supervising_provider_clone {
    from: athenadwh_provider_clone
    relationship: many_to_one
    sql_on: ${athenadwh_provider_clone.supervising_provider_id} = ${athenadwh_supervising_provider_clone.provider_id} ;;
  }

    join: oversight_provider {
      relationship: one_to_one
      sql_on: ${athenadwh_provider_clone.provider_user_name} = ${oversight_provider.user_name}
            AND ${care_request_flat.on_scene_date} >= ${oversight_provider.activated_date_date}
            AND (${care_request_flat.on_scene_date} < ${oversight_provider.deactivated_date_date} OR ${oversight_provider.deactivated_date_date} IS NULL);;
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
    relationship: one_to_one
   # type: inner
    sql_on: ${athenadwh_clinical_encounters_clone.appointment_id} = ${athenadwh_claims_clone.claim_appointment_id} ;;
  }

  join: athenadwh_valid_claims {
    relationship: one_to_one
    sql_on: ${athenadwh_claims_clone.claim_id} = ${athenadwh_valid_claims.claim_id} ;;
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
            ${athenadwh_letters_encounters.document_class}  = 'LETTER' AND
            (${athenadwh_letters_encounters.document_subclass} != 'LETTER_PATIENTCORRESPONDENCE' OR ${athenadwh_letters_encounters.document_subclass} IS NULL) AND
            (${athenadwh_letters_encounters.status} != 'DELETED' OR ${athenadwh_letters_encounters.status} IS NULL);;
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

  # join: athenadwh_lab_imaging_results {
  #   from:  athenadwh_documents_clone
  #   relationship:  one_to_one
  #   sql_on: ${athenadwh_document_crosswalk_clone.document_id} = ${athenadwh_lab_imaging_results.document_id} AND
  #     ${athenadwh_lab_imaging_results.document_class} IN ('IMAGINGRESULT', 'LABRESULT') AND
  #     ${athenadwh_lab_imaging_results.status} != 'DELETED' ;;
  # }

  join: athenadwh_lab_imaging_results {
    from:  athenadwh_clinical_results_clone
    relationship:  one_to_one
    sql_on: ${athenadwh_documents_clone.document_id} = ${athenadwh_lab_imaging_results.document_id} AND
      ${athenadwh_lab_imaging_results.clinical_order_type_group} IN ('IMAGING', 'LAB') AND
      ${athenadwh_documents_clone.status} != 'DELETED' ;;
  }

  join: athenadwh_lab_imaging_providers {
    from: athenadwh_clinical_providers_clone
    relationship: many_to_one
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

  join: athenadwh_documentaction {
    relationship: one_to_many
    sql_on: ${athenadwh_documents_clone.document_id} = ${athenadwh_documentaction.document_id} ;;
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

  join: athenadwh_clinicalresultobservation {
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_results_clone.clinical_result_id} = ${athenadwh_clinicalresultobservation.clinical_result_id} ;;
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

  join: provider_roster {
    relationship: one_to_one
    sql_on: ${athenadwh_letter_recipient_provider.npi} = ${provider_roster.npi}::varchar ;;
  }

  join: provider_network {
    relationship: many_to_one
    sql_on: ${provider_roster.provider_network_id} = ${provider_network.id} ;;
  }

  join: thpg_providers {
    relationship: one_to_one
    sql_on: ${athenadwh_letter_recipient_provider.npi}::int = ${thpg_providers.npi} ;;
  }

  join: multicare_providers {
    relationship: one_to_one
    sql_on: ${athenadwh_letter_recipient_provider.npi}::int = ${multicare_providers.npi} ;;
  }

  join: athenadwh_primary_care_provider {
    from: athenadwh_clinical_providers_clone
    relationship:  many_to_one
    sql_on: ${athenadwh_clinical_letters_clone.clinical_provider_recipient_id} = ${athenadwh_primary_care_provider.clinical_provider_id} AND
            ${athenadwh_clinical_letters_clone.role} = 'Primary Care Provider' ;;
  }

  # join: athenadwh_patients_clone {
  #   relationship: many_to_one
  #   sql_on: ${athenadwh_clinical_encounters_clone.patient_id} = ${athenadwh_patients_clone.patient_id} ;;
  # }

  join: athenadwh_patients_clone {
    relationship: one_to_one
    sql_on: ${patients.ehr_id} = ${athenadwh_patients_clone.patient_id}::varchar ;;
  }

  join: athenadwh_patientaudit {
    relationship: one_to_many
    sql_on: ${athenadwh_patients_clone.patient_id} = ${athenadwh_patientaudit.source_id};;
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

  join: athenadwh_collectibility_clone {
    from: athenadwh_transactions_clone
    relationship: one_to_many
    sql_on: ${athenadwh_claims_clone.claim_id} = ${athenadwh_collectibility_clone.claim_id} AND
            ${athenadwh_collectibility_clone.transaction_type} = 'PAYMENT' AND
            ${athenadwh_collectibility_clone.transaction_created_datetime_date} < ${athenadwh_claims_clone.claim_service_date}::date + interval '9 month';;
  }

  join: athenadwh_social_history_clone {
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.patient_id} = ${athenadwh_social_history_clone.patient_id} ;;
  }

  join: athenadwh_social_history_flat {
    relationship: many_to_one
    sql_on: ${athenadwh_clinical_encounters_clone.chart_id} = ${athenadwh_social_history_flat.chart_id} ;;
  }

  join: athenadwh_medical_history_clone {
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.chart_id} = ${athenadwh_medical_history_clone.chart_id} ;;
  }

  join: athenadwh_medical_history_flat {
    relationship: many_to_one
    sql_on: ${athenadwh_clinical_encounters_clone.chart_id} = ${athenadwh_medical_history_flat.chart_id} ;;
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

  join: cpt_code_dimensions_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.cpt_code_dim_id} = ${cpt_code_dimensions_clone.id} ;;
  }

  join: cpt_code_types_clone {
    relationship: one_to_one
    sql_on: ${cpt_code_types_clone.cpt_code} = ${cpt_code_dimensions_clone.cpt_code} ;;
  }

  join: on_route_locations {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${on_route_locations.care_request_id} ;;
  }


  join: icd_visit_joins_clone {
    relationship: many_to_one
    sql_on: ${transaction_facts_clone.visit_dim_number} = ${icd_visit_joins_clone.visit_dim_number} ;;
  }

  join: icd_code_dimensions_clone {
    relationship: many_to_one
    sql_on: ${icd_code_dimensions_clone.id} = CAST(${icd_visit_joins_clone.icd_dim_id} AS INT) ;;
  }

  join: icd_primary_code_dimensions_clone {
    from: icd_code_dimensions_clone
    view_label: "ICD Primary Code Dimensions Clone"
    relationship: many_to_one
    sql_on: ${icd_primary_code_dimensions_clone.id} = CAST(${icd_visit_joins_clone.icd_dim_id} AS INT) AND ${icd_visit_joins_clone.sequence_number} = 1 ;;
  }

  join: icd_secondary_code_dimensions_clone {
    from: icd_code_dimensions_clone
    view_label: "ICD Secondary Code Dimensions Clone"
    relationship: many_to_one
    sql_on: ${icd_secondary_code_dimensions_clone.id} = CAST(${icd_visit_joins_clone.icd_dim_id} AS INT) AND ${icd_visit_joins_clone.sequence_number} = 2 ;;
  }

  join: icd_tertiary_code_dimensions_clone {
    from: icd_code_dimensions_clone
    view_label: "ICD Tertiary Code Dimensions Clone"
    relationship: many_to_one
    sql_on: ${icd_secondary_code_dimensions_clone.id} = CAST(${icd_visit_joins_clone.icd_dim_id} AS INT) AND ${icd_visit_joins_clone.sequence_number} = 3 ;;
  }

  join: athenadwh_clinicalencounter_diagnosis {
    relationship: one_to_many
    sql_on: ${athenadwh_clinical_encounters_clone.clinical_encounter_id} = ${athenadwh_clinicalencounter_diagnosis.clinical_encounter_id}
    AND ${athenadwh_clinicalencounter_diagnosis.deleted_datetime_raw} IS NULL;;
  }

  join: athenadwh_clinicalencounter_dxicd10 {
    relationship: one_to_one
    #type: inner
    sql_on: ${athenadwh_clinicalencounter_diagnosis.clinical_encounter_dx_id} = ${athenadwh_clinicalencounter_dxicd10.clinical_encounter_dx_id} ;;
  }

  join: athenadwh_icdcodeall {
    relationship: many_to_one
    sql_on: ${athenadwh_clinicalencounter_dxicd10.icd_code_id} = ${athenadwh_icdcodeall.icd_code_id} ;;
  }

  join:  icd_code_to_disease_state_mapping {
    relationship: one_to_one
    sql_on: ${icd_code_dimensions_clone.diagnosis_code} = ${icd_code_to_disease_state_mapping.diagnosis_code};;
  }

  join: icd_primary_diagnosis_code {
    from: athenadwh_icdcodeall
    view_label: "ICD Primary Diagnosis Codes"
    relationship: one_to_one
    sql_on: ${athenadwh_clinicalencounter_dxicd10.icd_code_id} = ${icd_primary_diagnosis_code.icd_code_id} AND
    ${athenadwh_clinicalencounter_diagnosis.ordering} = 0 ;;
  }

  join: icd_secondary_diagnosis_code {
    from: athenadwh_icdcodeall
    view_label: "ICD Secondary Diagnosis Codes"
    relationship: one_to_one
    sql_on: ${athenadwh_clinicalencounter_dxicd10.icd_code_id} = ${icd_secondary_diagnosis_code.icd_code_id} AND ${athenadwh_clinicalencounter_diagnosis.ordering} = 1 ;;
  }

  join: icd_tertiary_diagnosis_code {
    from: athenadwh_icdcodeall
    view_label: "ICD Tertiary Diagnosis Codes"
    relationship: one_to_one
    sql_on: ${athenadwh_clinicalencounter_dxicd10.icd_code_id} = ${icd_tertiary_diagnosis_code.icd_code_id} AND ${athenadwh_clinicalencounter_diagnosis.ordering} = 2 ;;
  }

  join: drg_to_icd10_crosswalk {
    relationship: one_to_one
    sql_on: ${icd_code_dimensions_clone.diagnosis_code} = ${drg_to_icd10_crosswalk.icd_10_code} ;;
  }

  ### Diversion tables for cost savings model - 2/13/2019
  # join: diversion {
  #   relationship: many_to_many
  #   sql_on: ${icd_code_dimensions_clone.diagnosis_code} = ${diversion.diagnosis_code} AND
  #   ${icd_visit_joins_clone.sequence_number} <= 3 AND (
  #   ${care_request_flat.dc1} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc2} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc3} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc4} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc5} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc6} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc7} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc8} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc9} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc10} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc11} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc12} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc13} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc14} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc15} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc16} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc17} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc18} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc19} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc20} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc21} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc22} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc23} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc24} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc25} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc26} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc27} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc28} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc29} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc30} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc31} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc32} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc33} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc34} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc35} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc36} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc37} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc38} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc39} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc40} = ${diversion.diversion_category_id} OR
  #   ${care_request_flat.dc41} = ${diversion.diversion_category_id}) ;;
  # }

  join: diversion_flat {
    relationship: many_to_one
    sql_on: ${athenadwh_icdcodeall.diagnosis_code} = ${diversion_flat.diagnosis_code} AND
           (${athenadwh_clinicalencounter_diagnosis.ordering} <= 2 OR ${athenadwh_clinicalencounter_diagnosis.ordering} IS NULL) ;;
  }

  join: diversion_type {
    relationship: many_to_one
    sql_on: ${diversion_flat.diversion_type_id} = ${diversion_type.id} ;;
  }

  join: diversion_categories_flat {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${diversion_categories_flat.care_request_id};;
  }

  join: diversions_by_care_request {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${diversions_by_care_request.care_request_id} ;;
  }

  join: patient_details_flat {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${patient_details_flat.care_request_id} ;;
  }


  # join: diversion_savings_gross_by_insurance_group {
  #   relationship: many_to_one
  #   sql_on: ${diversion_type.id} = ${diversion_savings_gross_by_insurance_group.diversion_type_id}
  #       AND ${insurance_coalese_crosswalk.custom_insurance_grouping} = ${diversion_savings_gross_by_insurance_group.custom_insurance_grouping}
  #       AND ${care_request_flat.complete_date} >= ${diversion_savings_gross_by_insurance_group.activated_date}
  #       AND (${care_request_flat.complete_date} < ${diversion_savings_gross_by_insurance_group.deactivated_date}
  #       OR ${diversion_savings_gross_by_insurance_group.deactivated_date} IS NULL);;
  # }

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
    sql_on: ${care_requests.id} = ${survey_responses_flat_clone.care_request_id};;
  }

  # End cloned BI table joins
  ############################

  join: survey_response_facts_clone {
    relationship: one_to_many
    sql_on: ${care_requests.id} = ${survey_response_facts_clone.care_request_id} ;;
  }

  join: last_care_request {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${last_care_request.last_care_request_id} ;;
  }

  join: addressable_items {
    relationship: one_to_one
    sql_on: ${addressable_items.addressable_type} = 'CareRequest' and ${care_requests.id} = ${addressable_items.addressable_id};;
  }
  join: addresses {
    relationship: many_to_one
    sql_on:  ${addressable_items.address_id} = ${addresses.id} ;;
  }
  join: zipcodes {
    sql_on: ${addresses.zipcode_short} = ${zipcodes.zip};;
  }

  join: thr_texas_city_segments_by_zip {
    relationship: one_to_one
    sql_on: ${thr_texas_city_segments_by_zip.zip_code} = substring(${addresses.zipcode},1,5) ;;
  }

  join: income_pop_by_zipcode_small {
    sql_on: ${income_pop_by_zipcode_small.zipcode} =${addresses.zipcode_short} ;;
  }

  join: postal_codes {
    relationship: many_to_one
    sql_on: ${addresses.zipcode_short} = ${postal_codes.postalcode} ;;
  }

  join: slc_data {
    sql_on: ${addresses.zipcode_short}=${slc_data.zip_code}::varchar and ${slc_data.denver_comb_psa}='X' ;;
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

  join: shift_team_stops {
    relationship: one_to_many
    sql_on: ${shift_teams.id} = ${shift_team_stops.shift_team_id} ;;
  }

  join: shifts_end_of_shift_times {
    relationship: many_to_one
    sql_on: ${care_requests.shift_team_id} = ${shifts_end_of_shift_times.shift_team_id} ;;
  }

  join: shift_team_market_assignment_logs {
    relationship: one_to_many
    sql_on: ${shift_teams.id} = ${shift_team_market_assignment_logs.shift_team_id} ;;
  }

  join: breaks_pre_post_care_requests {
    relationship: one_to_one
    sql_on: ${shift_teams.id} = ${breaks_pre_post_care_requests.shift_team_id} ;;
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
    sql_on:  ${shift_teams.id}  =  ${shifts.id};;
  }

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_teams.car_id} = ${cars.id} ;;
  }

  join: users {
    relationship: one_to_one
    sql_on:  ${shift_team_members.user_id} = ${users.id};;
  }

  join: humanity_dashboard_provider_id_crosswalk {
    relationship: one_to_one
    sql_on: ${users.id} = ${humanity_dashboard_provider_id_crosswalk.user_id} ;;
  }

  join: shift_details {
    relationship: one_to_many
    sql_on: ${shift_details.employee_id} = ${humanity_dashboard_provider_id_crosswalk.humanity_id} ;;
  }

  join: medical_necessity_notes {
    from: notes
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${medical_necessity_notes.care_request_id} AND ${medical_necessity_notes.note_type} = 'medical-necessity' ;;
  }

  join: notes {
    relationship: one_to_many
    sql_on: ${care_requests.id} = ${notes.care_request_id};;
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

  join: followup_3day_employee {
    from: users
    relationship: many_to_one
    sql_on: ${care_request_flat.followup_3day_id} = ${followup_3day_employee.id} ;;
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

  # join: app_names {
  #   view_label: "Advanced Practice Provider Names"
  #   from: users
  #   relationship: one_to_one
  #   sql_on: ${users.id} = ${provider_profiles.user_id} AND ${provider_profiles.position} = 'advanced practice provider' ;;
  # }

  join: risk_assessments {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${risk_assessments.care_request_id} and ${risk_assessments.score} is not null ;;
  }

  join: icd_code_risk_assessment_crosswalk {
    relationship: one_to_many
    sql_on:upper(trim(${icd_primary_diagnosis_code.diagnosis_code_full})) = upper(trim(${icd_code_risk_assessment_crosswalk.diagnosis_code})) and upper(trim(${risk_assessments.protocol_name})) = upper(trim(${icd_code_risk_assessment_crosswalk.risk_assessments_protocol_name})) ;;
  }

  # 6/27/2019 - DE - This join used to be on care_request_requested, which I removed.  Not sure what this is going to break
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

  join: secondary_screening_provider_profile {
    from: provider_profiles
    relationship: many_to_one
    sql_on: ${secondary_screening_provider.id} = ${secondary_screening_provider_profile.user_id} ;;
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
  join: regional_markets {
    relationship: one_to_one
    sql_on: ${regional_markets.market_id} = ${markets.id_adj} ;;
  }

  join: market_start_date{
    sql_on: ${markets.id}=${market_start_date.market_id} ;;
  }

  join: markets_state_level_metrics {
    relationship: many_to_one
    sql_on: ${markets.state} = ${markets_state_level_metrics.state} ;;
  }

  join: market_geo_locations {
    relationship: one_to_one
    sql_on: ${markets.id} = ${market_geo_locations.market_id} ;;
  }

  join: clinical_partner_revenue_forecast {
    relationship: one_to_one
    sql_on: ${markets.id} = ${clinical_partner_revenue_forecast.market_id} AND
            ${care_request_flat.complete_month} = ${clinical_partner_revenue_forecast.financial_month_month};;
  }

  join: labor_expense_by_month {
    relationship: one_to_one
    sql_on: ${markets.id} = ${labor_expense_by_month.market_id} AND
      ${care_request_flat.complete_month} = ${labor_expense_by_month.reporting_month_month};;
  }

  join: states {
    relationship: one_to_one
    sql_on: ${markets.state} = ${states.abbreviation} ;;
  }

  join: insurances {
    relationship: many_to_one
    sql_on: ${care_requests.patient_id} = ${insurances.patient_id} AND
            ${insurances.priority} = '1' AND
            ${insurances.patient_id} IS NOT NULL AND
            COALESCE(${insurances.start_date},${care_request_flat.on_scene_date}) <= ${care_request_flat.on_scene_date} AND
            COALESCE(${insurances.end_date},${care_request_flat.on_scene_date}) >= ${care_request_flat.on_scene_date};;
#     sql_where: ${insurances.eligible} <> 'Ineligible' ;;
    }

    join: insurance_plans {
      relationship: many_to_one
      sql_on: ${insurances.package_id} = ${insurance_plans.package_id} AND
            ${insurance_plans.state_id} = ${states.id} ;;
#       sql_where: ${insurance_plans.active} ;;
    }

  join: insurance_member_id {
    relationship: one_to_one
    sql_on: ${care_requests.patient_id} = ${insurance_member_id.patient_id} ;;
  }

  join: primary_insurance_plans {
    from: insurance_plans
    relationship: many_to_one
    sql_on: ${insurances.package_id} = ${primary_insurance_plans.package_id} AND
            ${insurances.company_name} = ${primary_insurance_plans.name} AND
            ${primary_insurance_plans.state_id} = ${states.id} AND ${primary_insurance_plans.primary} IS TRUE ;;
  }

  join: self_report_insurance_crosswalk {
    from: primary_payer_dimensions_clone
    relationship: many_to_one
    sql_on: ${care_request_flat.self_report_primary_package_id} = ${self_report_insurance_crosswalk.insurance_package_id} ;;
  }

  join: insurance_coalese {
    relationship: many_to_one
    sql_on: ${insurance_coalese.care_request_id} = ${care_requests.id} ;;
  }


  join: insurance_coalese_crosswalk {
    from: primary_payer_dimensions_clone
    relationship: many_to_one
    sql_on: ${insurance_coalese.package_id_coalese} = ${insurance_coalese_crosswalk.insurance_package_id}
            AND ${insurance_coalese_crosswalk.custom_insurance_grouping} IS NOT NULL;;
  }

  join: expected_allowable_corporate {
    relationship: many_to_one
    sql_on: ${markets.id} = ${expected_allowable_corporate.market_id} AND
            ${insurance_coalese_crosswalk.custom_insurance_grouping} = ${expected_allowable_corporate.custom_insurance_grouping}  AND
            ${athenadwh_claims_clone.service_month} = ${expected_allowable_corporate.claim_month_month} ;;
  }


  join: insurance_classifications {
    relationship: many_to_one
    sql_on: ${insurance_plans.insurance_classification_id} = ${insurance_classifications.id} ;;
  }

#   join: care_request_complete{
#     relationship: one_to_many
#     from: care_request_statuses
#     sql_on: ${care_request_complete.care_request_id} = ${care_requests.id} and ${care_request_complete.name}='complete';;
#   }

  join: care_request_requested{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_requested.care_request_id} = ${care_requests.id} and ${care_request_requested.name}='requested';;
  }

#   join: care_request_accepted{
#     relationship: one_to_many
#     from: care_request_statuses
#     sql_on: ${care_request_accepted.care_request_id} = ${care_requests.id} and ${care_request_accepted.name}='accepted';;
#   }

#   join: care_request_archived{
#     relationship: one_to_many
#     from: care_request_statuses
#     sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='archived';;
#   }

  join: care_request_scheduled{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_scheduled.care_request_id} = ${care_requests.id} and ${care_request_scheduled.name}='scheduled';;
  }

  join: care_request_flat {
    relationship: one_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }
  join: callers {
    sql_on: ${care_requests.caller_id} =${callers.id} ;;
  }

  join: service_lines {
    sql_on: ${care_requests.service_line_id} =${service_lines.id} ;;
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

  join: patient_level_aggregated_measures {
    relationship: one_to_one
    sql_on: ${patients.id} = ${patient_level_aggregated_measures.id} ;;
  }

  join: min_patient_complete_visit {
    relationship: many_to_one
    sql_on:  ${min_patient_complete_visit.patient_id} = ${patients.id} ;;
  }

  join: driver_licenses {
    relationship: one_to_one
    sql_on: ${patients.id} = ${driver_licenses.patient_id} ;;
  }

  join: dtc_ff_patients {
    sql_on: ${patients.id} = ${dtc_ff_patients.patient_id} ;;
  }

  join: population_health_channels {
    from: channel_items
    relationship: many_to_one
    sql_on: ${eligible_patients.channel_item_id} = ${population_health_channels.id} ;;
  }

  join: eligible_patients {
    relationship: one_to_one
    sql_on: ${patients.id} = ${eligible_patients.patient_id} ;;
  }

  join: vitals_flat {
    relationship: one_to_one
    sql_on: ${care_requests.id} = ${vitals_flat.care_request_id} ;;
  }

  join: power_of_attorneys {
    sql_on:  ${patients.id} =${power_of_attorneys.patient_id} ;;
  }

  join: channel_items {
    relationship: many_to_one
    sql_on:  ${care_requests.channel_item_id} = ${channel_items.id} ;;
  }

  join: growth_update_channels {
    relationship: one_to_one
    sql_on: ${channel_items.id} =${growth_update_channels.identifier_id} and ${growth_update_channels.identifier_type} = 'channel';;
  }

  join: sf_accounts{
    sql_on: ${sf_accounts.channel_items_id}=${channel_items.id} ;;
  }

  join: channel_item_emr_providers {
    relationship: many_to_one
    sql_on: ${channel_items.id} = ${channel_item_emr_providers.channel_item_id} ;;
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
        OR (${care_request_flat.origin_phone} = ${invoca_clone.caller_id} and ${care_request_flat.origin_phone} is not null)
        )
        and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_request_flat.created_mountain_raw})) < (60*60*1.5)
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
    sql_on: ${care_request_flat.contact_id} = ${incontact_clone.contact_id}
                  ;;
  }

  join: genesys_conversation_summary {
    sql_on: ${care_request_flat.contact_id} = ${genesys_conversation_summary.conversationid}
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

  join: breaks {
    relationship: one_to_one
    sql_on: ${breaks.shift_team_id} = ${shift_teams.id} ;;
  }

  join: market_break_configs {
    relationship: many_to_one
    sql_on: ${breaks.market_break_config_id} = ${market_break_configs.id};;
  }

}

explore: shift_details {
  join: markets {
    relationship: one_to_many
    sql_on:  ${markets.humanity_id} = ${shift_details.schedule_location_id}::varchar  ;;
  }

  join: markets_loan {
    from: markets
    relationship: one_to_many
    sql_on:  ${markets_loan.humanity_id} = ${shift_details.schedule_location_id_w_loan}::varchar  ;;
  }
  join: humanity_dashboard_provider_id_crosswalk {
    relationship: many_to_one
    sql_on: ${shift_details.employee_id} = ${humanity_dashboard_provider_id_crosswalk.humanity_id} ;;
  }
  join: target_staffing {
    sql_on: ${markets_loan.id} = ${target_staffing.market_id}
      and ${shift_details.local_expected_start_month}=${target_staffing.month_month}
      and  ${shift_details.local_expected_end_day_of_week} = ${target_staffing.dow};;
  }


}

# Scott test
explore: test_shift_details {
  extends: [shift_details]
  from: shift_details
  fields: [shift_details.employee_name,markets.name]

}

explore: cars {
  join: markets {
    relationship: one_to_many
    sql_on: ${markets.id} = ${cars.market_id} ;;
  }

  join: shift_teams {
    relationship: one_to_many
    sql_on: ${cars.id} = ${shift_teams.car_id} ;;
  }
}

explore: operational_excellence_metrics {}
explore: operational_excellence_app_screening {}
explore: operational_excellence_csc_escalation {}

explore: shift_planning_facts_clone {
  #view_label: "Shift Information"

  join: shift_planning_shifts_clone {
    relationship: one_to_one
    sql_on:  ${shift_planning_facts_clone.shift_id}=${shift_planning_shifts_clone.shift_id} and ${shift_planning_shifts_clone.imported_after_shift} = 1 ;;
  }

  join: shift_planning_future {
    from: shift_planning_shifts_clone
    relationship: one_to_one
    sql_on:  ${shift_planning_facts_clone.shift_id}=${shift_planning_future.shift_id} and ${shift_planning_future.imported_after_shift} = 0 ;;
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

  join: provider_profiles {
    relationship: one_to_one
    sql_on: ${provider_profiles.user_id} = ${users.id} ;;
  }

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_planning_facts_clone.car_dim_id} = ${cars.id} ;;
  }

  join: timezones {
    relationship: one_to_one
    sql_on: ${timezones.rails_tz} = ${markets.sa_time_zone} ;;
  }
}

explore: shift_planning_hourly_capacity {

  join: markets {
    relationship: one_to_many
    sql_on: ${markets.humanity_id} = ${shift_planning_hourly_capacity.schedule_location_id} ;;
  }
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

explore: productivity_data_clone {

  join: market_market_dim_crosswalk {
    relationship: many_to_one
    sql_on: ${productivity_data_clone.market_dim_id} = ${market_market_dim_crosswalk.market_dim_id} ;;
  }

  join: markets {
    relationship: one_to_one
    sql_on: ${market_market_dim_crosswalk.market_id} = ${markets.id} ;;
    }

  join: market_start_date{
    relationship: one_to_one
    sql_on: ${markets.id}=${market_start_date.market_id} ;;
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

  join: timezones {
    relationship: many_to_one
    sql_on: ${markets.sa_time_zone} = ${timezones.rails_tz} ;;
  }

  join: shift_teams {
    relationship: one_to_one
    sql_on: ${shift_teams.car_id} = ${shift_planning_facts_clone.car_dim_id} AND
            ${shift_planning_facts_clone.local_actual_start_date} = ${shift_teams.start_date} ;;
  }

  join: shifts{
    relationship: one_to_one
    sql_on:  ${shift_teams.id}  =  ${shifts.id};;
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

  join: channel_item_emr_providers {
    relationship: many_to_one
    sql_on: ${channel_items.id} = ${channel_item_emr_providers.channel_item_id} ;;
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


  join: markets_channel {
    from: markets
    relationship: many_to_one
    sql_on: ${channels.market_id} = ${markets_channel.id} ;;
  }

}

explore: invoca_clone {
  sql_always_where: (${invoca_clone.utm_medium} !='self report');;

  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
             and ${invoca_clone.caller_id} = ${incontact_clone.from_number}
                  ;;

  }

  join: genesys_conversation_summary {
    sql_on: abs(EXTRACT(EPOCH FROM (${genesys_conversation_summary.conversationstarttime_raw} - ${invoca_clone.start_time_raw}))) <5000
                         and ${invoca_clone.caller_id} = ${genesys_conversation_summary.ani}
                          ;;
  }

  join: genesys_conversation_wrapup {
    sql_on: ${genesys_conversation_summary.conversationid}=${genesys_conversation_wrapup.conversationid} ;;
  }



  join: patients {
    sql_on:   (
                ${patients.mobile_number} = ${invoca_clone.caller_id}
              )
             and ${patients.mobile_number} is not null   ;;
  }

  join: care_request_flat {
    sql_on: (${patients.id} = ${care_request_flat.patient_id}  OR ${care_request_flat.origin_phone} = ${invoca_clone.caller_id})
      and (
            abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_request_flat.created_mountain_raw})) < (60*60*1.5)
          );;
  }

  join: care_requests {
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

  join: care_request_flat {
    sql_on:
        (
          (
            ${patients.id} = ${care_request_flat.patient_id} and  (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_request_flat.care_request_id})
          OR
          (
            ${care_request_flat.origin_phone} = ${invoca_clone.caller_id}
            and
            ${care_request_flat.origin_phone} is not null
          )
        )
        AND
        abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_request_flat.created_mountain_raw})) < (60*60*1.5)
        );;
  }

  join: care_requests  {
    relationship: many_to_one
    sql_on: ${care_request_flat.care_request_id} = ${care_requests.id} ;;
  }


  join: dtc_ff_patients {
    sql_on: ${patients.id} = ${care_requests.patient_id}
         OR ${patients.id} = ${web_care_requests.patient_id} ;;
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

  join: care_request_flat {
    sql_on:
      (
        (
          ${patients.id} = ${care_request_flat.patient_id} and  (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_request_flat.care_request_id})
          OR
          (${care_request_flat.origin_phone} = ${invoca_clone.caller_id} and ${care_request_flat.origin_phone} is not null )
        )
        AND
        abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_request_flat.created_mountain_raw})) < (60*60*1.5)
      );;
  }


    join: care_requests  {
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

    join: care_request_flat {
      sql_on:
            (
              (
                ${patients.id} = ${care_request_flat.patient_id} and (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_request_flat.care_request_id})
                OR
                (${care_request_flat.origin_phone} = ${invoca_clone.caller_id} and ${care_request_flat.origin_phone} is not null )
              )
              AND
              abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_request_flat.created_mountain_raw})) < (60*60*1.5)
            );;
    }
      join: care_requests {
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

      join: care_request_flat {
        sql_on:
            (
              (
                ${patients.id} = ${care_request_flat.patient_id} and (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_request_flat.care_request_id})
                OR
                (${care_request_flat.origin_phone} = ${invoca_clone.caller_id} and ${care_request_flat.origin_phone} is not null )
              )
              AND
              abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_request_flat.created_mountain_raw})) < (60*60*1.5)

            );;

        }


          join: care_requests  {
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
      sql_on: ${insurance_plans.state_id} = ${states.id};;
    }

    join: insurance_network_insurance_plans {
      relationship: one_to_one
      sql_on: ${insurance_plans.package_id} = ${insurance_network_insurance_plans.package_id} ;;
    }

    join: insurance_networks {
      relationship: many_to_one
      sql_on: ${insurance_network_insurance_plans.insurance_network_id} = ${insurance_networks.id} ;;
    }

    join: markets {
      relationship: many_to_one
      sql_on: ${insurance_networks.market_id} = ${markets.id_adj} AND ${states.abbreviation} = ${markets.state} ;;
    }

    join: insurance_network_network_referrals {
      relationship: one_to_many
      sql_on: ${insurance_networks.id} = ${insurance_network_network_referrals.insurance_network_id} ;;
    }

    join: network_referrals {
      relationship: many_to_one
      sql_on: ${insurance_network_network_referrals.network_referral_id} = ${network_referrals.id} ;;
    }

    join: insurance_classifications {
      relationship: many_to_one
      sql_on: ${insurance_plans.insurance_classification_id} = ${insurance_classifications.id} ;;
    }

#     join: insurance_plans_insurance_networks {
#       relationship: one_to_one
#       sql_on: ${insurance_plans.id} = ${insurance_plans_insurance_networks.id} ;;
#     }
#
#     join: network_referral_markets {
#       from: markets
#       relationship: many_to_one
#       sql_on: ${insurance_networks.market_id} = ${network_referral_markets.id_adj} ;;
#     }

  }

  explore: incontact_clone {

          join: invoca_clone {
            sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 3800
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
            sql_on: ${care_requests.created_mountain_date} = ${incontact_clone.start_date} and ${incontact_clone.market_id} =${care_requests.market_id_adj}
                and ${care_requests.deleted_raw} IS NULL
            ;;
          }
          join: care_request_flat {
            relationship: many_to_one
            sql_on: ${care_request_flat.care_request_id} = ${care_requests.id}   AND  (${care_request_flat.secondary_resolved_reason} NOT IN ('Test Case', 'Duplicate') OR ${care_request_flat.secondary_resolved_reason} IS NULL) ;;
          }


          join: care_request_flat_exact {
            from:  care_request_flat
            sql_on: (${patients.id} = ${care_request_flat_exact.patient_id}  OR ${care_request_flat_exact.origin_phone} = ${incontact_clone.from_number})
            and (
                   abs(EXTRACT(EPOCH FROM ${incontact_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_request_flat_exact.created_mountain_raw})) < (60*60*24)
            );;
            }

          join: care_requests_exact {
            from: care_requests
            relationship: many_to_one
            sql_on: ${care_request_flat_exact.care_request_id} = ${care_requests_exact.id} ;;
          }




          join:   care_request_flat_contact_id{
            from: care_request_flat
            sql_on: ${care_request_flat_contact_id.contact_id} = ${incontact_clone.contact_id};;
          }

          join: care_requests_contact_id {
            from: care_requests
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


explore:thpg_providers  {
  join: thpg_zipcode {
  sql_on: ${thpg_providers.zipcd} = ${thpg_zipcode.zipcodes} ;;
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

  join: care_request_flat {
    sql_on:
        (
          (
            ${patients.id} = ${care_request_flat.patient_id} and  (${web_care_requests.id} is null OR ${web_care_requests.id} != ${care_request_flat.care_request_id})
          OR
          (
            ${care_request_flat.origin_phone} = ${marketing_data_processed.invoca_phone_number}
            and
            ${care_request_flat.origin_phone} is not null
          )
        )
        AND
        abs(EXTRACT(EPOCH FROM ${marketing_data_processed.invoca_start_raw})-EXTRACT(EPOCH FROM ${care_request_flat.created_mountain_raw})) < (60*60*1.5)
        );;
  }

  join: dtc_ff_patients {
    sql_on: ${patients.id} = ${care_requests.patient_id}
      OR ${patients.id} = ${web_care_requests.patient_id} ;;
  }



  join: care_requests  {
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



}
explore: last_patient_seen {

}

explore: houston_zipcodes_processed{
  join: zipcodes {
    sql_on: ${zipcodes.zip}::int =${houston_zipcodes_processed.zipcode} and ${zipcodes.market_id}=165 ;;
  }

}
explore: psu_count_data{
  join: zipcodes {
    sql_on: ${zipcodes.zip}::int =${psu_count_data.zipcode}::int and ${zipcodes.market_id}=165 ;;
  }
  }



explore: iora_patients{
  join: patients {
    sql_on: ${iora_patients.dob_raw} = ${patients.dob}
              and
            lower(${patients.first_name}) = lower(${iora_patients.first_name})
              and
            lower(${patients.last_name}) = lower(${iora_patients.last_name});;
  }

  join: care_requests {
    sql_on: ${patients.id} = ${care_requests.patient_id} ;;
  }

  join: care_request_flat {
    sql_on: ${care_requests.id} = ${care_request_flat.care_request_id} ;;
  }

  join: channel_items {
    sql_on: ${channel_items.id} = ${care_requests.channel_item_id} ;;
  }

  join: visit_facts_clone {
    sql_on: ${care_requests.id} = ${visit_facts_clone.care_request_id} ;;
  }

  join: survey_responses_flat_clone {
    relationship: one_to_one
    sql_on: ${survey_responses_flat_clone.visit_dim_number} = ${visit_facts_clone.visit_dim_number};;
  }

}
explore: incontact_aggregated_clone  {

  join: markets {
    sql_on: ${markets.id} = ${incontact_aggregated_clone.market_id} ;;
  }


  join: goal_inbound_calls_dec {
    sql_on:  ${goal_inbound_calls_dec.date_date} =${incontact_aggregated_clone.date_date}
    and ${goal_inbound_calls_dec.market_id} =${markets.id};;
  }
}

explore: provider_address {

  join: markets {
    relationship: one_to_many
    sql_on: ${markets.id} = ${provider_address.location} ;;
  }
}

explore: slc_data {
  sql_always_where: ${slc_data.denver_comb_psa}='X' ;;
  join: zipcodes {
    sql_on: ${zipcodes.zip}::int=${slc_data.zip_code} and ${zipcodes.market_id}=159 ;;
  }
  }

explore: users {

  join: user_roles {
    relationship: many_to_one
    sql_on: ${user_roles.user_id} = ${users.id} ;;
  }

  join: roles {
    relationship: one_to_many
    sql_on: ${roles.id} = ${user_roles.role_id} ;;
  }

  join: provider_profiles {
    relationship: one_to_one
    sql_on: ${users.id} = ${provider_profiles.user_id} ;;
  }
}

explore: growth_update_channels {
  join: markets {
    sql_on: ${markets.id} =${growth_update_channels.market_id} ;;
  }
  join: channel_items {
    sql_on: ${channel_items.id}=${growth_update_channels.identifier_id} and ${growth_update_channels.identifier_type} = 'channel' ;;
  }
  join: care_request_channel {
    from: care_requests
    sql_on: ${channel_items.id} =${care_request_channel.channel_item_id} and ${care_request_channel.created_raw} >='2019-01-01'
    and ${care_request_channel.market_id} =${growth_update_channels.market_id};;
  }

  join: care_request_channel_flat {
    from: care_request_flat
    sql_on: ${care_request_channel.id} = ${care_request_channel_flat.care_request_id} ;;
  }

  join: primary_payer_dimensions_clone {
    sql_on: ${primary_payer_dimensions_clone.insurance_package_id}::int=${growth_update_channels.identifier_id}
    and ${growth_update_channels.identifier_type} = 'payer' ;;
  }
  join: insurance_coalese {
    sql_on: ${insurance_coalese.package_id_coalese} = ${primary_payer_dimensions_clone.insurance_package_id} ;;
  }

  join: care_request_payer_flat {
    from: care_request_flat
    sql_on: ${insurance_coalese.care_request_id} = ${care_request_payer_flat.care_request_id} and ${care_request_payer_flat.created_raw} >'2018-10-01'
    and ${care_request_payer_flat.market_id} =${growth_update_channels.market_id};;
  }

}

explore: primary_payer_dimensions_clone {
  join: insurance_plans {
    sql_on: ${insurance_plans.package_id}=${primary_payer_dimensions_clone.insurance_package_id} ;;
  }
  join: states {
    sql_on: ${states.id} = ${insurance_plans.state_id} ;;
  }
  join: markets {
    sql_on: lower(${states.abbreviation}) = lower(${markets.state});;
  }
}
explore: thr_zips {
  join: zipcodes {
    sql_on: ${zipcodes.zip}::int=${thr_zips.zipcode} and ${zipcodes.market_id}= 169 ;;
  }
}

explore: tch_low_acuity_zips {
  join: zipcodes {
    relationship: one_to_one
    sql_on: ${zipcodes.zip}=${tch_low_acuity_zips.zipcode} ;;
  }
}

explore: diversion_flat {
  join: icd_code_dimensions_clone {
    sql_on: ${diversion_flat.diagnosis_code} = ${icd_code_dimensions_clone.diagnosis_code} ;;
  }

  join: diversion_type {
    sql_on: ${diversion_flat.diversion_type_id} =${diversion_type.id} ;;
  }

}

explore: expected_allowable_corporate {
  join: markets {
    relationship: one_to_many
    sql_on: ${markets.id} = ${expected_allowable_corporate.market_id} ;;
  }

  join: market_start_date{
    sql_on: ${markets.id}=${market_start_date.market_id} ;;
  }

}

explore: intraday_monitoring {
  join: markets {
    sql_on: ${markets.name} =${intraday_monitoring.market} ;;
  }
  join: care_request_flat {
    sql_on: (${care_request_flat.market_id} =${markets.id} or ${intraday_monitoring.market}='All')
            and
            ${care_request_flat.on_scene_date} =${intraday_monitoring.created_date} ;;
  }
  join: care_requests {
    sql_on: ${care_requests.id} =${care_request_flat.care_request_id} ;;
  }
  join: shift_teams {
    relationship: many_to_one
    sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  }

  join: shifts{
    relationship: many_to_one
    sql_on:  ${shift_teams.id}  =  ${shifts.id};;
  }

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_teams.car_id} = ${cars.id} ;;
  }


}

explore: intraday_monitoring_agg {
}

explore: expected_allowables_market_budget {
  join: markets {
    relationship: one_to_many
    sql_on: ${markets.id} = ${expected_allowables_market_budget.markets_id} ;;
  }
}


explore: genesys_conversation_summary {
  join: number_to_market {
    relationship: one_to_one
    sql_on: ${number_to_market.number}=${genesys_conversation_summary.dnis} ;;
  }

  join: genesys_conversation_wrapup {
    sql_on: ${genesys_conversation_summary.conversationid}=${genesys_conversation_wrapup.conversationid} ;;
  }

  join: invoca_clone {
    sql_on: abs(EXTRACT(EPOCH FROM (${genesys_conversation_summary.conversationstarttime_raw} - ${invoca_clone.start_time_raw}))) <5000
    and ${invoca_clone.caller_id} = ${genesys_conversation_summary.ani}
    ;;
  }

  join: markets {
    relationship: one_to_one
    sql_on: ${markets.id}=${number_to_market.market_id} ;;
  }

  join: regional_markets {
    relationship: one_to_one
    sql_on: ${regional_markets.market_id} = ${markets.id_adj} ;;
  }

  join: care_request_flat {
    sql_on: ${genesys_conversation_summary.conversationid} =${care_request_flat.contact_id};;
  }

  join: patients {
    sql_on:   (
                ${patients.mobile_number} = ${genesys_conversation_summary.ani}
              )
             and ${patients.mobile_number} is not null   ;;
  }

  join: care_request_flat_number{
    from: care_request_flat
    sql_on: (${patients.id} = ${care_request_flat_number.patient_id}  OR ${care_request_flat_number.origin_phone} = ${genesys_conversation_summary.ani})
      and abs(EXTRACT(EPOCH FROM (${genesys_conversation_summary.conversationstarttime_raw} - ${care_request_flat_number.created_mountain_raw}))) <36000;;
  }
}
explore: propensity_by_zip {
  join: zipcodes {
    sql_on: ${zipcodes.zip} = ${propensity_by_zip.zipcode} ;;
  }
  join: tivity_data {
    sql_on: ${tivity_data.zipcode} =${propensity_by_zip.zipcode} ;;
  }
  join: markets {
    sql_on: ${zipcodes.market_id}=${markets.id} ;;
  }
}

explore: tivity_data {
  join: zipcodes {
    sql_on: ${zipcodes.zip} = ${tivity_data.zipcode} ;;
  }
  join: propensity_by_zip {
    sql_on: ${tivity_data.zipcode} =${propensity_by_zip.zipcode} ;;
  }
  join: markets {
    sql_on: ${zipcodes.market_id}=${markets.id} ;;
  }
}

explore: shift_teams
 {

  join: care_requests {
    relationship: one_to_many
    sql_on: ${shift_teams.id} = ${care_requests.shift_team_id} ;;
  }

  join: care_request_flat {
    relationship: one_to_many
    sql_on: ${care_requests.id} = ${care_request_flat.care_request_id} ;;
  }

  join: shift_team_members {
    relationship: one_to_many
    sql_on: ${shift_teams.id} = ${shift_team_members.shift_team_id} ;;
  }

  join: users {
    relationship: one_to_one
    sql_on: ${shift_team_members.user_id} = ${users.id} ;;
  }

  join: provider_profiles {
    relationship: one_to_one
    sql_on: ${users.id} = ${provider_profiles.user_id} ;;
  }

  join: shift_team_market_assignment_logs {
    sql_on: ${shift_teams.id} = ${shift_team_market_assignment_logs.shift_team_id} AND ${shift_team_market_assignment_logs.lend} ;;
  }
  join: cars {
    sql_on: ${cars.id}=${shift_teams.car_id} ;;
  }

  join: markets {
    sql_on: ${markets.id}= coalesce(${shift_team_market_assignment_logs.market_id}, ${cars.market_id}) ;;
  }

  join: regional_markets {
    relationship: one_to_one
    sql_on: ${regional_markets.market_id} = ${markets.id_adj} ;;
  }

  join: timezones {
    relationship: many_to_one
    sql_on: ${timezones.rails_tz} = ${markets.sa_time_zone} ;;
  }

  join: target_staffing {
    sql_on: ${markets.id} = ${target_staffing.market_id}
      and ${shift_teams.start_month}=${target_staffing.month_month}
      and  ${shift_teams.start_day_of_week} = ${target_staffing.dow};;
  }
  join: goals_by_day_of_week {
    sql_on: ${markets.id_adj} =${goals_by_day_of_week.market_id} and ${goals_by_day_of_week.month_month}=${shift_teams.start_month};;
  }

  join: budget_projections_by_market_clone {
    sql_on: ${markets.id_adj} = ${budget_projections_by_market_clone.market_dim_id} AND ${shift_teams.start_month} = ${budget_projections_by_market_clone.month_month} ;;
  }

}

explore: budget_projections_by_market_clone {
  join: markets {
    sql_on: ${markets.id} = ${budget_projections_by_market_clone.market_dim_id} ;;
  }
}

explore: diversion_savings_gross_by_insurance_group {}
explore: idle_time_summary {
  join: overflow_by_day_market {
    sql_on: ${idle_time_summary.start_date_date} = ${overflow_by_day_market.created_date} and ${overflow_by_day_market.name} = ${idle_time_summary.name_smfr} ;;
  }
}

explore: ga_adwords_cost_clone{
  sql_always_where: (lower(${adwords_campaigns_clone.campaign_name}) like '%search%' or ${adwords_campaigns_clone.campaign_name} is null)  and ${date_raw} >= '2020-01-01' and ${adcost} is not null;;
  join: adwords_campaigns_clone {
    sql_on: ${adwords_campaigns_clone.campaign_id} =${ga_adwords_cost_clone.adwordscampaignid} ;;
  }
  join: markets {
    sql_on: ${adwords_campaigns_clone.market_id_new} =${markets.id} ;;
  }
}

explore: cac_costs {
  join: markets {
    sql_on: ${cac_costs.market_id} =${markets.id} ;;
  }
  join: regional_markets {
    relationship: one_to_one
    sql_on: ${regional_markets.market_id} = ${markets.id_adj} ;;
  }

  join: care_request_flat {
    sql_on: ${care_request_flat.on_scene_month} = ${cac_costs.date_month} and ${care_request_flat.market_id} = ${cac_costs.market_id};;
  }

  join: sem_run_rate {
    sql_on: ${sem_run_rate.date_month}=${cac_costs.date_month} and ${cac_costs.market_id}=${sem_run_rate.id_adj};;
  }

}

explore: mbo_metrics {
  join: mbo_metrics_quarterly_goals {
    relationship: one_to_many
    sql_on: ${mbo_metrics_quarterly_goals.quarter_id} = ${mbo_metrics.quarter_id} ;;
  }
}

explore: mbo_metrics_quarterly_goals {}

explore: zizzl_employee_roster {}

explore: sf_accounts {
  sql_always_where:  ${markets.name} != 'West Metro Fire Rescue';;

  join: sf_markets_mapping {
    sql_on: ${sf_markets_mapping.market}=${sf_accounts.market} ;;
  }
  join: markets {
    type: full_outer
    sql_on: ${markets.id}=${sf_markets_mapping.market_id} ;;
  }
  join: regional_markets {
    relationship: one_to_one
    sql_on: ${regional_markets.market_id} = ${markets.id_adj} ;;
  }

  join: channel_items {
    sql_on: ${channel_items.id} =${sf_accounts.channel_items_id} ;;
  }
  join: care_requests{
    sql_on: ${care_requests.channel_item_id}=${channel_items.id} ;;
  }
  join: care_request_flat{
    sql_on: ${care_request_flat.care_request_id}=${care_requests.id} ;;
  }
  join: sf_activities {
    sql_on: ${sf_activities.account_id} = ${sf_accounts.account_id} ;;
  }
  join: sf_contacts {
    sql_on: ${sf_contacts.account_id} =${sf_accounts.account_id} ;;
  }
  join: parent_accounts {
    from: sf_accounts
    sql_on: ${parent_accounts.account_id} =  ${sf_accounts.parent_account_id};;
  }
}

explore: sf_activities {
  sql_always_where:  ${markets.name} != 'West Metro Fire Rescue';;
  join: sf_accounts {
    sql_on: ${sf_activities.account_id} = ${sf_accounts.account_id} ;;
  }
  join: sf_markets_mapping {
    sql_on: ${sf_markets_mapping.market}=${sf_accounts.market} ;;
  }
  join: markets {
    type: full_outer
    sql_on: ${markets.id}=${sf_markets_mapping.market_id}   ;;
  }

  join: regional_markets {
    relationship: one_to_one
    sql_on: ${regional_markets.market_id} = ${markets.id_adj} ;;
  }

  join: channel_items {
    sql_on: ${channel_items.id} =${sf_accounts.channel_items_id} ;;
  }
  join: care_requests{
    sql_on: ${care_requests.channel_item_id}=${channel_items.id} ;;
  }
  join: care_request_flat{
    sql_on: ${care_request_flat.care_request_id}=${care_requests.id} ;;
  }
  join: parent_accounts {
    from: sf_accounts
    sql_on: ${parent_accounts.account_id}  = ${sf_accounts.parent_account_id};;
  }
}


explore: renown_all_data {}
