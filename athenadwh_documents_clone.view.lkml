view: athenadwh_documents_clone {
  sql_table_name: looker_scratch.athenadwh_documents_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: clinical_order_genus {
    type: string
    sql: ${TABLE}.clinical_order_genus ;;
  }

  dimension: clinical_order_type {
    type: string
    sql: ${TABLE}.clinical_order_type ;;
  }

  dimension: pcp_referrals_flag {
    type: yesno
    sql: ${clinical_order_type} = 'PRIMARY CARE REFERRAL' ;;
  }

  dimension: thr_referral {
    description: "A flag indicating the patient received a PCP referral to THR Access Center"
    type: number
    sql:  CASE
            WHEN ${clinical_order_type} = 'PRIMARY CARE REFERRAL' AND
                 ${status} <> 'DELETED' AND ${athenadwh_documents_provider.name} = 'THR ACCESS CENTER' THEN 1
            ELSE 0
          END ;;
  }

  measure: thr_pcp_referral  {
    type: max
    sql: ${thr_referral} ;;
  }

  measure: third_party_lab_imaging {
    type: max
    description: "A flag indicating that third party labs or imaging were ordered"
    sql: CASE
          WHEN ${document_class} = 'ORDER' AND ${athenadwh_order_providers.provider_category} = 'Performed by Third Party' THEN 1
          ELSE 0
        END ;;
  }

  dimension: rapid_strep_test {
    type: yesno
    description: "A flag indicating a rapid strep test"
    sql: ${clinical_order_type} LIKE '%RAPID STREP GROUP A%' ;;
  }

  dimension: referral_type {
    type: string
    sql: CASE
          WHEN ${clinical_order_type} LIKE '%REFERRAL%' THEN INITCAP(SUBSTRING(${clinical_order_type}, 1, POSITION('REFERRAL' in ${clinical_order_type})-1))
          ELSE INITCAP(${clinical_order_type})
        END
          ;;
    drill_fields: [
      athenadwh_referral_providers.name,
      athenadwh_referral_providers.provider_category
    ]
  }

  measure: order_type_concat {
    label: "Description Of Items Ordered"
    type: string
    sql: string_agg(DISTINCT ${clinical_order_type}, ' | ') ;;
  }

  measure: prescription_info_concat {
    label: "Description Of Prescription Medications"
    type: string
    sql: array_to_string(array_agg(DISTINCT
         CASE WHEN ${athenadwh_patient_prescriptions.prescribed_yn} = 'Y' THEN
            CONCAT(${clinical_order_type}, ': ',
             ${athenadwh_patient_prescriptions.dosage_route}, ': ',
             ${athenadwh_patient_prescriptions.frequency})
            ELSE NULL END
            ), ' | ')  ;;
  }

  measure: genus_type_concat {
    label: "Genus Of Items Ordered"
    type: string
    sql: string_agg(DISTINCT ${clinical_order_genus}, ' | ') ;;
  }

  dimension: prescriptions_flag {
    type: yesno
    sql: ${document_class} = 'PRESCRIPTION' ;;
  }

  dimension: clinical_letter_flag {
    type: yesno
    sql: ${document_class} LIKE '%LETTER%' ;;
  }

  dimension: medicine_administered_onscene {
    type: yesno
    description: "A flag indicating that medicine was administered on-scene"
    sql: ${document_class} = 'PRESCRIPTION' AND ${clinical_provider_id} IS NULL ;;
  }

  dimension: labs_flag {
    type: yesno
    sql: ${document_class} = 'LABRESULT' ;;
  }

  dimension: imaging_flag {
    type: yesno
    sql: ${document_class} = 'IMAGINGRESULT' ;;
  }

  dimension: dme_flag {
    type: yesno
    sql: ${document_class} = 'DME' ;;
  }

  dimension: orders_flag {
    type: yesno
    sql: ${document_class} = 'ORDER' ;;
  }

  dimension: pending_order_description {
    type: string
    hidden: yes
    sql: CASE WHEN ${document_class} = 'ORDER' AND ${status} LIKE 'SUBMIT%' AND ${clinical_order_type} NOT LIKE '%REFERRAL%' THEN ${clinical_order_type}
         ELSE NULL END  ;;
  }

  measure: pending_order_descriptions {
    type: string
    description: "The descriptions of all pending lab/imaging order"
    sql: array_to_string(array_agg(DISTINCT ${pending_order_description}), ' | ')  ;;
  }

  dimension: provider_referrals_flag {
    type: yesno
    sql: ${clinical_order_type} LIKE '%REFERRAL%' AND ${clinical_order_type} NOT LIKE 'HOME HEALTH%' ;;
  }

  dimension: home_health_referrals_flag {
    type: yesno
    sql: ${clinical_order_type} LIKE 'HOME HEALTH%REFERRAL' ;;
  }

  dimension: pcp_referral_flag {
    type: yesno
    sql: ${clinical_order_type} = 'PRIMARY CARE REFERRAL' ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: created_datetime {
    type: string
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: deleted_datetime {
    type: string
    sql: ${TABLE}.deleted_datetime ;;
  }

  dimension: document_class {
    type: string
    sql: ${TABLE}.document_class ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: document_subclass {
    type: string
    sql: ${TABLE}.document_subclass ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: route {
    type: string
    sql: ${TABLE}.route ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: deleted_status {
    type: yesno
    sql: ${status} = 'DELETED' ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: count_documents {
    type: count_distinct
    sql: ${document_id} ;;
  }

  measure: count_encounters {
    type: count_distinct
    sql: ${clinical_encounter_id} ;;
  }

  measure: count_letters {
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    sql_distinct_key: ${care_request_flat.care_request_id} ;;
    filters: {
      field: clinical_letter_flag
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
  }

  measure: count_pcp_letters {
    type: count_distinct
    description: "Count of clinical notes sent to PCP"
    sql: ${care_request_flat.care_request_id} ;;
    sql_distinct_key: ${care_request_flat.care_request_id} ;;
    filters: {
      field: clinical_letter_flag
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
    filters: {
      field: care_team_members.pcp_provider_flag
      value: "yes"
    }
  }

  measure: count_non_pcp_letters {
    type: count_distinct
    description: "Count of clinical notes sent to someone other than PCP"
    sql: ${care_request_flat.care_request_id} ;;
    sql_distinct_key: ${care_request_flat.care_request_id} ;;
    filters: {
      field: clinical_letter_flag
      value: "yes"
    }
    filters: {
      field: care_requests.billable_est
      value: "yes"
    }
    filters: {
      field: care_team_members.pcp_provider_flag
      value: "no"
    }
  }

  measure: clinical_notes_boolean {
    type: yesno
    description: "A flag indicating that any clinical note was sent to a provider or specialist"
    sql: ${count_letters} > 0 ;;
  }

  dimension: letter_created_date {
    description: "Populates dates that are associated with a 'LETTER' document class only"
    type: date
    sql: CASE
        WHEN ${document_class} LIKE '%LETTER%' THEN ${created_date}
        ELSE NULL
        END;;
  }

  measure: letter_created_date_minimum {
    description: "Populates the minimum athenadwh_documents_clone.created_date value to identify the first document sent date"
    type: date
    sql:  min(${letter_created_date}) ;;

  }
}
