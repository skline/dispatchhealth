view: athena_patient {
  sql_table_name: athena.patient ;;
  drill_fields: [new_patient_id]
  view_label: "Athena Patients"

  dimension: patient_id {
    type: number
    primary_key: yes
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: new_patient_id {
    primary_key: no
    description: "When patients are merged, this field will indicate the surviving patient record"
    group_label: "IDs"
    type: string
    sql: ${TABLE}."new_patient_id" ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: address {
    type: string
    group_label: "Contact Information"
    sql: INITCAP(${TABLE}."address") ;;
  }

  dimension: address_2 {
    type: string
    group_label: "Contact Information"
    sql: INITCAP(${TABLE}."address_2") ;;
  }

  dimension: city {
    type: string
    group_label: "Contact Information"
    sql: INITCAP(${TABLE}."city") ;;
  }

  dimension_group: consent_to_call_eff {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."consent_to_call_eff_date" ;;
  }

  dimension: consent_to_call_flag {
    type: string
    sql: ${TABLE}."consent_to_call_flag" ;;
  }

  dimension_group: created_at {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

  dimension: current_department_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."current_department_id" ;;
  }

  dimension_group: deceased {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."deceased_date" ;;
  }

  dimension: default_prescription_prov_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."default_prescription_prov_id" ;;
  }

  dimension_group: dob {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."dob" ;;
  }

  dimension: email {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."email" ;;
  }

  dimension: emergency_contact_name {
    type: string
    group_label: "Emergency Contact Information"
    sql: ${TABLE}."emergency_contact_name" ;;
  }

  dimension: emergency_contact_phone {
    type: string
    group_label: "Emergency Contact Information"
    sql: ${TABLE}."emergency_contact_phone" ;;
  }

  dimension: emergency_contact_relationship {
    type: string
    group_label: "Emergency Contact Information"
    sql: ${TABLE}."emergency_contact_relationship" ;;
  }

  dimension: enterprise_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."enterprise_id" ;;
  }

  dimension: first_name {
    type: string
    group_label: "Contact Information"
    sql: INITCAP(${TABLE}."first_name") ;;
  }

  dimension: first_last_name {
    type: string
    description: "First Last"
    group_label: "Contact Information"
    sql: CONCAT(${first_name}, ' ', ${last_name}) ;;
  }

  dimension: last_first_mi_name {
    type: string
    description: "Last, First, MI"
    group_label: "Contact Information"
    sql: CASE WHEN ${middle_initial} IS NOT NULL THEN CONCAT(${last_name}, ', ', ${first_name}, ', ', ${middle_initial})
         ELSE CONCAT(${last_name}, ', ', ${first_name})
         END ;;
  }

  dimension: address_full {
    type: string
    description: "Address, Address2, City, State Zip"
    group_label: "Contact Information"
    sql: CASE WHEN ${address_2} IS NOT NULL THEN CONCAT(${address},', ',${address_2},', ',${city},', ',${state}, ' ', ${zip})
        ELSE CONCAT(${address},', ',${city},', ',${state}, ' ', ${zip})
        END ;;
  }

  dimension: guarantor_address {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_address" ;;
  }

  dimension: guarantor_address_2 {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_address_2" ;;
  }

  dimension: guarantor_city {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_city" ;;
  }

  dimension_group: guarantor_dob {
    type: time
    group_label: "Guarantor Contact Information"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."guarantor_dob" ;;
  }

  dimension: guarantor_first_name {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_first_name" ;;
  }

  dimension: guarantor_last_name {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_last_name" ;;
  }

  dimension: guarantor_middle_initial {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_middle_initial" ;;
  }

  dimension: guarantor_name_suffix {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_name_suffix" ;;
  }

  dimension: guarantor_phone {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_phone" ;;
  }

  dimension: guarantor_relationship {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_relationship" ;;
  }

  dimension: guarantor_ssn {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_ssn" ;;
  }

  dimension: guarantor_state {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_state" ;;
  }

  dimension: guarantor_zip {
    type: string
    group_label: "Guarantor Contact Information"
    sql: ${TABLE}."guarantor_zip" ;;
  }

  dimension: hold_statement_reason {
    type: string
    sql: ${TABLE}."hold_statement_reason" ;;
  }

  dimension_group: insured_sig_effective {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."insured_sig_effective_date" ;;
  }

  dimension: insured_sig_on_file_flag {
    type: string
    sql: ${TABLE}."insured_sig_on_file_flag" ;;
  }

  dimension: last_name {
    type: string
    group_label: "Contact Information"
    sql: INITCAP(${TABLE}."last_name") ;;
  }

  dimension: middle_initial {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."middle_initial" ;;
  }

  dimension: name_suffix {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."name_suffix" ;;
  }

  dimension: patient_char {
    type: string
    hidden: yes
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_home_phone {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."patient_home_phone" ;;
  }

  dimension_group: patient_sig_effective {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."patient_sig_effective_date" ;;
  }

  dimension: patient_sig_on_file_flag {
    type: string
    sql: ${TABLE}."patient_sig_on_file_flag" ;;
  }

  dimension: patient_ssn {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."patient_ssn" ;;
  }

  dimension: patient_status {
    type: string
    description: "a for active, d for deceased"
    group_label: "Contact Information"
    sql: ${TABLE}."patient_status" ;;
  }

  dimension: preferred_lab_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."preferred_lab_id" ;;
  }

  dimension: primary_provider_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."primary_provider_id" ;;
  }

  dimension: privacy_notice_given_by {
    type: string
    group_label: "Privacy Notice Given"
    group_item_label: "By"
    sql: ${TABLE}."privacy_notice_given_by" ;;
  }

  dimension_group: privacy_notice_given {
    type: time
    group_label: "Privacy Notice Given"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."privacy_notice_given_date" ;;
  }

  dimension: privacy_notice_given_dept_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."privacy_notice_given_dept_id" ;;
  }

  dimension: privacy_notice_given_flag {
    type: string
    group_label: "Privacy Notice Given"
    group_item_label: "Flag"
    sql: ${TABLE}."privacy_notice_given_flag" ;;
  }

  dimension: provider_group_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."provider_group_id" ;;
  }

  dimension_group: registration {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."registration_date" ;;
  }

  dimension: registration_department_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."registration_department_id" ;;
  }

  dimension: sex {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."sex" ;;
  }

  dimension: state {
    type: string
    group_label: "Contact Information"
    sql: ${TABLE}."state" ;;
  }

  dimension: test_patient_yn {
    type: string
    sql: ${TABLE}."test_patient_yn" ;;
  }

  dimension_group: updated_at {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."updated_at" ;;
  }

  dimension: zip {
    type: zipcode
    group_label: "Contact Information"
    sql: ${TABLE}."zip" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_distinct_patients {
    type: count_distinct
    sql: ${patient_id} ;;
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      new_patient_id,
      first_name,
      last_name,
      guarantor_first_name,
      guarantor_last_name,
      emergency_contact_name,
      patient.first_name,
      patient.last_name,
      patient.new_patient_id,
      patient.guarantor_first_name,
      patient.guarantor_last_name,
      patient.emergency_contact_name,
      claim.count,
      document_letters.count,
      document_orders.count,
      document_others.count,
      document_prescriptions.count,
      document_results.count,
      patient.count
    ]
  }
}
