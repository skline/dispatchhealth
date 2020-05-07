view: collective_medical {
  sql_table_name: collective_medical.collective_medical ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: 12m_ed_visit_count {
    type: number
    sql: ${TABLE}."12m_ed_visit_count" ;;
  }

  dimension: 3m_ed_visit_count {
    type: number
    sql: ${TABLE}."3m_ed_visit_count" ;;
  }

  dimension: 6m_ed_visit_count {
    type: number
    sql: ${TABLE}."6m_ed_visit_count" ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension: __discharge_date_updated {
    type: yesno
    hidden: yes
    sql: ${TABLE}."__discharge_date_updated" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: __processed_date {
    type: string
    hidden: yes
    sql: ${TABLE}."__processed_date" ;;
  }

  dimension_group: admit {
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
    sql: ${TABLE}."admit_date" ;;
  }

  dimension: admitted_ip {
    type: yesno
    description: "Admitted In-Patient"
    sql: ${TABLE}."admitted_ip" ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}."care_request_id" ;;
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

  dimension: diagnoses {
    type: string
    sql: ${TABLE}."diagnoses" ;;
  }

  dimension: diagnosis_codes {
    type: string
    sql: ${TABLE}."diagnosis_codes" ;;
  }

  dimension_group: discharge {
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
    sql: ${TABLE}."discharge_date" ;;
  }

  dimension: encounter_account_number {
    type: string
    sql: ${TABLE}."encounter_account_number" ;;
  }

  dimension: encounter_chief_complaint {
    type: string
    sql: ${TABLE}."encounter_chief_complaint" ;;
  }

  dimension: encounter_discharge_disposition {
    type: string
    sql: ${TABLE}."encounter_discharge_disposition" ;;
  }

  dimension: facility_hl7_identifier {
    type: string
    sql: ${TABLE}."facility_hl7_identifier" ;;
  }

  dimension: major_class {
    type: string
    description: "Emergency, Inpatient, or Observation"
    sql: ${TABLE}."major_class" ;;
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

  dimension: visit_facility {
    type: string
    sql: ${TABLE}."visit_facility" ;;
  }

  dimension: visit_type {
    type: string
    description: "The reason for the visit: Surgery, Oncology, General Medicine, etc."
    sql: ${TABLE}."visit_type" ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
