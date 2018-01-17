view: visit_facts {
  sql_table_name: jasperdb.visit_facts ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: accepted {
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
    sql: ${TABLE}.accepted_time ;;
  }

  dimension: car_dim_id {
    type: number
    sql: ${TABLE}.car_dim_id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: channel_dim_id {
    type: number
    sql: ${TABLE}.channel_dim_id ;;
  }

  dimension: chief_complaint {
    type: string
    sql: ${TABLE}.chief_complaint ;;
  }

  dimension_group: complete {
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
    sql: ${TABLE}.complete_time ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: csc_shift_id {
    type: string
    sql: ${TABLE}.csc_shift_id ;;
  }

  dimension: day_14_followup_outcome {
    type: string
    sql: ${TABLE}.day_14_followup_outcome ;;
  }

  dimension: day_30_followup_outcome {
    type: string
    sql: ${TABLE}.day_30_followup_outcome ;;
  }

  dimension: day_3_followup_outcome {
    type: string
    sql: ${TABLE}.day_3_followup_outcome ;;
  }

  dimension: emt_shift_id {
    type: string
    sql: ${TABLE}.emt_shift_id ;;
  }

  dimension: facility_type_dim_id {
    type: number
    sql: ${TABLE}.facility_type_dim_id ;;
  }

  dimension: latitude {
    hidden: yes
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: letter_recipient_dim_id {
    type: number
    sql: ${TABLE}.letter_recipient_dim_id ;;
  }

  dimension: letter_sent {
    type: yesno
    sql: ${TABLE}.letter_sent ;;
  }

  dimension_group: local_accepted {
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
    sql: ${TABLE}.local_accepted_time ;;
  }

  dimension_group: local_complete {
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
    sql: ${TABLE}.local_complete_time ;;
  }

  dimension_group: local_on_route {
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
    sql: ${TABLE}.local_on_route_time ;;
  }

  dimension_group: local_on_scene {
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
    sql: ${TABLE}.local_on_scene_time ;;
  }

  dimension_group: local_requested {
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
    sql: ${TABLE}.local_requested_time ;;
  }

  dimension: location_dim_id {
    type: number
    sql: ${TABLE}.location_dim_id ;;
  }

  dimension: visit_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: longitude {
    hidden: yes
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: new_patient {
    type: yesno
    sql: ${TABLE}.new_patient ;;
  }

  dimension: no_charge_entry_reason {
    type: string
    sql: ${TABLE}.no_charge_entry_reason ;;
  }

  dimension: nppa_shift_id {
    type: string
    sql: ${TABLE}.nppa_shift_id ;;
  }

  dimension_group: on_route {
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
    sql: ${TABLE}.on_route_time ;;
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
    sql: ${TABLE}.on_scene_time ;;
  }

  dimension: other_resolve_reason {
    type: string
    sql: ${TABLE}.other_resolve_reason ;;
  }

  dimension: patient_dim_id {
    type: number
    sql: ${TABLE}.patient_dim_id ;;
  }

  dimension: patient_employer_dim_id {
    type: number
    sql: ${TABLE}.patient_employer_dim_id ;;
  }

  dimension: provider_dim_id {
    type: number
    sql: ${TABLE}.provider_dim_id ;;
  }

  dimension: request_type_dim_id {
    type: number
    sql: ${TABLE}.request_type_dim_id ;;
  }

  dimension_group: requested {
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
    sql: ${TABLE}.requested_time ;;
  }

  dimension: resolve_reason {
    type: string
    sql: ${TABLE}.resolve_reason ;;
  }

  dimension: resolved {
    type: yesno
    sql: ${TABLE}.resolved ;;
  }

  dimension: secondary_resolve_reason {
    type: string
    sql: ${TABLE}.secondary_resolve_reason ;;
  }

  dimension: seconds_in_queue {
    type: number
    sql: ${TABLE}.seconds_in_queue ;;
  }

  dimension: seconds_of_travel_time {
    type: number
    sql: ${TABLE}.seconds_of_travel_time ;;
  }

  dimension: seconds_on_scene {
    type: number
    sql: ${TABLE}.seconds_on_scene ;;
  }

  dimension: hours_on_scene {
    type: number
    sql: 1.0 * ${seconds_on_scene} / 3600 ;;
  }

  dimension: total_acct_receivable_payments {
    type: number
    sql: ${TABLE}.total_acct_receivable_payments ;;
  }

  dimension: total_acct_receivable_transactions {
    type: number
    sql: ${TABLE}.total_acct_receivable_transactions ;;
  }

  dimension: total_charge {
    type: number
    sql: ${TABLE}.total_charge ;;
  }

  dimension: total_expected_allowable {
    type: number
    sql: ${TABLE}.total_expected_allowable ;;
  }

  dimension: total_rvus {
    type: number
    sql: ${TABLE}.total_rvus ;;
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

  dimension: visit_dim_number {
    type: string
    sql: ${TABLE}.visit_dim_number ;;
  }

  dimension: work_rvus {
    type: number
    sql: ${TABLE}.work_rvus ;;
  }

  dimension: billable_visit {
    type: yesno
    sql: ${visit_dim_number} IS NOT NULL AND ${no_charge_entry_reason} IS NULL ;;
  }

  measure: count {
    type: count
    drill_fields: [details*]
  }

  measure: count_of_billable_visits {
    type: count
    filters: {
      field: billable_visit
      value: "yes"
    }

    drill_fields: [details*]
  }

  measure: average_on_scene_time {
    type: average
    sql: ${seconds_on_scene} ;;
    drill_fields: [details*]
  }

  set: details {
    fields: [id, seconds_on_scene, total_charge]
  }

}
