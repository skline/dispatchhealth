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
    sql: ${TABLE}.admit_date ;;
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
    sql: ${TABLE}.discharge_date ;;
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

  dimension: 12_hour_cm_admit_inpatient {
    description: "Inpatient admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 3600) <= 12 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  }

  dimension: 12_hour_cm_admit_emergency {
    description: "Emergency admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 3600) <= 12 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
  }


   dimension: 3_day_cm_admit_inpatient {
    description: "Inpatient admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 3 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  }

  dimension: 3_day_cm_admit_observation {
    description: "Observation admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 3 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'observation';;
  }

  dimension: 3_day_cm_admit_emergency {
    description: "Emergency admittance recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 3 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
  }

  dimension: 14_day_cm_admit_inpatient {
    description: "Inpatient admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 14 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  }

  dimension: 14_day_cm_admit_observation {
    description: "Observation admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 14 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'observation';;
  }

  dimension: 14_day_cm_admit_emergency {
    description: "Emergency admittance recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 14 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency';;
  }

  dimension: 30_day_cm_admit_inpatient {
    description: "Inpatient admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 30 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient';;
  }

  dimension: 30_day_cm_admit_observation {
    description: "Observation admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 30 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'observation';;
  }

  dimension: 30_day_cm_admit_emergency {
    description: "Emergency admittance recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 30 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and  lower(${major_class}) = 'emergency';;
  }

  measure: count_12_hour_cm_admit_inpatient {
    description: "Count Inpatient admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: 12_hour_cm_admit_inpatient
      value: "yes"
    }
  }

  measure: count_12_hour_cm_admit_emergency {
    description: "Count Emergency admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id}  ;;
    filters: {
      field: 12_hour_cm_admit_emergency
      value: "yes"
    }
  }

 measure: count_3_day_cm_admit_inpatient {
    description: "Count Inpatient admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: 3_day_cm_admit_inpatient
      value: "yes"
    }
  }

  measure: count_3_day_cm_admit_observation {
    description: "Count Observation admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id}  ;;
    filters: {
      field: 3_day_cm_admit_observation
      value: "yes"
    }
  }

    measure: count_3_day_cm_admit_emergency {
      description: "Count Emergency admittances recorded by Collective Medical within 3 days of the DH care request on-scene date"
      type: count_distinct
      sql: ${care_request_id}  ;;
      filters: {
        field: 3_day_cm_admit_emergency
        value: "yes"
      }
  }

  measure: count_14_day_cm_admit_inpatient {
    description: "Count Inpatient admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id}  ;;
    filters: {
      field: 14_day_cm_admit_inpatient
      value: "yes"
    }
  }

  measure: count_14_day_cm_admit_observation {
    description: "Count Observation admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id}  ;;
    filters: {
      field: 14_day_cm_admit_observation
      value: "yes"
    }
  }

  measure: count_14_day_cm_admit_emergency {
    description: "Count Emergency admittances recorded by Collective Medical within 14 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id}  ;;
    filters: {
      field: 14_day_cm_admit_emergency
      value: "yes"
    }
  }

  measure: count_30_day_cm_admit_inpatient {
    description: "Count Inpatient admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id}  ;;
    filters: {
      field: 30_day_cm_admit_inpatient
      value: "yes"
    }
  }

  measure: count_30_day_cm_admit_observation {
    description: "Count Observation admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id}  ;;
    filters: {
      field: 30_day_cm_admit_observation
      value: "yes"
    }
  }

  measure: count_30_day_cm_admit_emergency {
    description: "Count Emergency admittances recorded by Collective Medical within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_id}  ;;
    filters: {
      field: 30_day_cm_admit_emergency
      value: "yes"
    }
  }

  measure: count_er_admits {
    type: count_distinct

  }

  dimension: 30day_ed_admittance_framework {
    description: "Categorizes the first recorded ED admittance by day wihtin the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 1 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '01'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 2 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '02'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 3 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '03'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 4 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '04'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 5 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '05'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 6 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '06'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 7 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '07'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 8 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '08'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 9 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '09'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 10 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '10'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 11 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '11'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 12 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '12'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 13 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '13'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 14 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '14'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 15 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '15'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 16 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '16'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 17 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '17'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 18 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '18'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 19 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '19'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 20 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '20'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 21 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '21'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 22 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '22'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 23 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '23'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 24 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '24'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 25 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '25'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 26 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '26'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 27 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '27'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 28 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '28'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 29 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '29'
    WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 30 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'emergency' THEN '30'
    ELSE 'Greater then 30 Days'
    END
    ;;

  }

  dimension: 30day_inpatient_admittance_framework {
    description: "Categorizes the first recorded ED admittance by day wihtin the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) <= 1 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '01'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 2 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '02'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 3 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '03'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 4 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '04'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 5 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '05'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 6 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '06'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 7 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '07'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 8 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '08'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 9 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '09'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 10 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '10'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 11 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '11'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 12 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '12'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 13 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '13'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 14 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '14'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 15 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '15'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 16 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '16'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 17 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '17'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 18 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '18'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 19 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '19'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 20 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '20'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 21 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '21'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 22 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '22'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 23 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '23'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 24 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '24'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 25 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '25'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 26 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '26'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 27 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '27'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 28 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '28'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 29 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '29'
          WHEN ((EXTRACT(EPOCH FROM ${admit_date})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_date})) / 86400) = 30 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${major_class}) = 'inpatient' THEN '30'
          ELSE 'Greater then 30 Days'
          END
          ;;

    }


}
