view: patient {
  sql_table_name: athena.patient ;;
  drill_fields: [new_patient_id]
  view_label: "Athena Patients (DEV)"

  dimension: patient_id {
    type: number
    primary_key: yes
    group_label: "IDs"
    # hidden: yes
    sql: ${TABLE}."patient_id" ;;
  }

  dimension: new_patient_id {
    primary_key: no
    type: string
    sql: ${TABLE}."new_patient_id" ;;
  }

  dimension: __batch_id {
    type: string
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}."address" ;;
  }

  dimension: address_2 {
    type: string
    sql: ${TABLE}."address_2" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
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

  dimension_group: created {
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: current_department_id {
    type: number
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
    sql: ${TABLE}."email" ;;
  }

  dimension: emergency_contact_name {
    type: string
    sql: ${TABLE}."emergency_contact_name" ;;
  }

  dimension: emergency_contact_phone {
    type: string
    sql: ${TABLE}."emergency_contact_phone" ;;
  }

  dimension: emergency_contact_relationship {
    type: string
    sql: ${TABLE}."emergency_contact_relationship" ;;
  }

  dimension: enterprise_id {
    type: number
    sql: ${TABLE}."enterprise_id" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: guarantor_address {
    type: string
    sql: ${TABLE}."guarantor_address" ;;
  }

  dimension: guarantor_address_2 {
    type: string
    sql: ${TABLE}."guarantor_address_2" ;;
  }

  dimension: guarantor_city {
    type: string
    sql: ${TABLE}."guarantor_city" ;;
  }

  dimension_group: guarantor_dob {
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
    sql: ${TABLE}."guarantor_dob" ;;
  }

  dimension: guarantor_first_name {
    type: string
    sql: ${TABLE}."guarantor_first_name" ;;
  }

  dimension: guarantor_last_name {
    type: string
    sql: ${TABLE}."guarantor_last_name" ;;
  }

  dimension: guarantor_middle_initial {
    type: string
    sql: ${TABLE}."guarantor_middle_initial" ;;
  }

  dimension: guarantor_name_suffix {
    type: string
    sql: ${TABLE}."guarantor_name_suffix" ;;
  }

  dimension: guarantor_phone {
    type: string
    sql: ${TABLE}."guarantor_phone" ;;
  }

  dimension: guarantor_relationship {
    type: string
    sql: ${TABLE}."guarantor_relationship" ;;
  }

  dimension: guarantor_ssn {
    type: string
    sql: ${TABLE}."guarantor_ssn" ;;
  }

  dimension: guarantor_state {
    type: string
    sql: ${TABLE}."guarantor_state" ;;
  }

  dimension: guarantor_zip {
    type: string
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
    sql: ${TABLE}."last_name" ;;
  }

  dimension: middle_initial {
    type: string
    sql: ${TABLE}."middle_initial" ;;
  }

  dimension: name_suffix {
    type: string
    sql: ${TABLE}."name_suffix" ;;
  }

  dimension: patient_char {
    type: string
    sql: ${TABLE}."patient_char" ;;
  }

  dimension: patient_home_phone {
    type: string
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
    sql: ${TABLE}."patient_ssn" ;;
  }

  dimension: patient_status {
    type: string
    sql: ${TABLE}."patient_status" ;;
  }

  dimension: preferred_lab_id {
    type: number
    sql: ${TABLE}."preferred_lab_id" ;;
  }

  dimension: primary_provider_id {
    type: number
    sql: ${TABLE}."primary_provider_id" ;;
  }

  dimension: privacy_notice_given_by {
    type: string
    sql: ${TABLE}."privacy_notice_given_by" ;;
  }

  dimension_group: privacy_notice_given {
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
    sql: ${TABLE}."privacy_notice_given_date" ;;
  }

  dimension: privacy_notice_given_dept_id {
    type: number
    sql: ${TABLE}."privacy_notice_given_dept_id" ;;
  }

  dimension: privacy_notice_given_flag {
    type: string
    sql: ${TABLE}."privacy_notice_given_flag" ;;
  }

  dimension: provider_group_id {
    type: number
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
    sql: ${TABLE}."registration_department_id" ;;
  }

  dimension: sex {
    type: string
    sql: ${TABLE}."sex" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: test_patient_yn {
    type: string
    sql: ${TABLE}."test_patient_yn" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."zip" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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
