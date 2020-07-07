view: first_major_class_admit_date_post_visit {
  sql_table_name: collective_medical.first_major_class_admit_date_post_visit ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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

  dimension: dh_patient_id {
    type: number
    sql: ${TABLE}."dh_patient_id" ;;
  }

  dimension_group: first_admit_post_visit {
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
    sql: ${TABLE}."first_admit_post_visit" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: major_class {
    type: string
    sql: ${TABLE}."major_class" ;;
  }

  dimension_group: on_scene {
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
    sql: ${TABLE}."on_scene_date" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
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

  measure: count {
    type: count
    drill_fields: [id]
  }

  dimension: 30day_ed_admittance_framework {
    description: "Categorizes the first recorded ED admittance by day wihtin the first 30 days from the DH on-scene date"
    type: string
    sql: CASE WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) <= 1 and lower(${major_class}) = 'emergency' THEN '01'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 2 and lower(${major_class}) = 'emergency' THEN '02'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 3 and lower(${major_class}) = 'emergency' THEN '03'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 4 and lower(${major_class}) = 'emergency' THEN '04'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 5 and lower(${major_class}) = 'emergency' THEN '05'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 6 and lower(${major_class}) = 'emergency' THEN '06'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 7 and lower(${major_class}) = 'emergency' THEN '07'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 8 and lower(${major_class}) = 'emergency' THEN '08'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 9 and lower(${major_class}) = 'emergency' THEN '09'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 10 and lower(${major_class}) = 'emergency' THEN '10'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 11 and lower(${major_class}) = 'emergency' THEN '11'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 12 and lower(${major_class}) = 'emergency' THEN '12'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 13 and lower(${major_class}) = 'emergency' THEN '13'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 14 and lower(${major_class}) = 'emergency' THEN '14'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 15 and lower(${major_class}) = 'emergency' THEN '15'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 16 and lower(${major_class}) = 'emergency' THEN '16'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 17 and lower(${major_class}) = 'emergency' THEN '17'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 18 and lower(${major_class}) = 'emergency' THEN '18'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 19 and lower(${major_class}) = 'emergency' THEN '19'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 20 and lower(${major_class}) = 'emergency' THEN '20'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 21 and lower(${major_class}) = 'emergency' THEN '21'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 22 and lower(${major_class}) = 'emergency' THEN '22'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 23 and lower(${major_class}) = 'emergency' THEN '23'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 24 and lower(${major_class}) = 'emergency' THEN '24'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 25 and lower(${major_class}) = 'emergency' THEN '25'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 26 and lower(${major_class}) = 'emergency' THEN '26'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 27 and lower(${major_class}) = 'emergency' THEN '27'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 28 and lower(${major_class}) = 'emergency' THEN '28'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 29 and lower(${major_class}) = 'emergency' THEN '29'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 30 and lower(${major_class}) = 'emergency' THEN '30'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) > 30 and lower(${major_class}) = 'emergency' THEN 'Greater then 30 Days'
          ELSE NULL
          END
          ;;

    }

    dimension: 30day_inpatient_admittance_framework {
      description: "Categorizes the first recorded ED admittance by day wihtin the first 30 days from the DH on-scene date"
      type: string
      sql: CASE WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) <= 1 and lower(${major_class}) = 'inpatient' THEN '01'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 2 and lower(${major_class}) = 'inpatient' THEN '02'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 3 and lower(${major_class}) = 'inpatient' THEN '03'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 4 and lower(${major_class}) = 'inpatient' THEN '04'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 5 and lower(${major_class}) = 'inpatient' THEN '05'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 6 and lower(${major_class}) = 'inpatient' THEN '06'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 7 and lower(${major_class}) = 'inpatient' THEN '07'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 8 and lower(${major_class}) = 'inpatient' THEN '08'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 9 and lower(${major_class}) = 'inpatient' THEN '09'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 10 and lower(${major_class}) = 'inpatient' THEN '10'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 11 and lower(${major_class}) = 'inpatient' THEN '11'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 12 and lower(${major_class}) = 'inpatient' THEN '12'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 13 and lower(${major_class}) = 'inpatient' THEN '13'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 14 and lower(${major_class}) = 'inpatient' THEN '14'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 15 and lower(${major_class}) = 'inpatient' THEN '15'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 16 and lower(${major_class}) = 'inpatient' THEN '16'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 17 and lower(${major_class}) = 'inpatient' THEN '17'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 18 and lower(${major_class}) = 'inpatient' THEN '18'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 19 and lower(${major_class}) = 'inpatient' THEN '19'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 20 and lower(${major_class}) = 'inpatient' THEN '20'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 21 and lower(${major_class}) = 'inpatient' THEN '21'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 22 and lower(${major_class}) = 'inpatient' THEN '22'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 23 and lower(${major_class}) = 'inpatient' THEN '23'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 24 and lower(${major_class}) = 'inpatient' THEN '24'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 25 and lower(${major_class}) = 'inpatient' THEN '25'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 26 and lower(${major_class}) = 'inpatient' THEN '26'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 27 and lower(${major_class}) = 'inpatient' THEN '27'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 28 and lower(${major_class}) = 'inpatient' THEN '28'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 29 and lower(${major_class}) = 'inpatient' THEN '29'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) = 30 and lower(${major_class}) = 'inpatient' THEN '30'
          WHEN ((EXTRACT(EPOCH FROM ${first_admit_post_visit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 86400) > 30 and lower(${major_class}) = 'inpatient' THEN 'Greater then 30 Days'
          ELSE NULL
          END
          ;;

      }

}
