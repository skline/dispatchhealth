view: care_requests {
  sql_table_name: public.care_requests ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: accepted_order {
    type: number
    sql: ${TABLE}.accepted_order ;;
  }

  dimension: activated_by {
    type: string
    sql: ${TABLE}.activated_by ;;
  }

  dimension: appointment_type {
    type: string
    sql: ${TABLE}.appointment_type ;;
  }

  dimension: centura_connect_aco {
    type: string
    sql: ${TABLE}.centura_connect_aco ;;
  }

  dimension: channel_item_id {
    type: number
    sql: ${TABLE}.channel_item_id ;;
  }

  dimension: chief_complaint {
    type: string
    sql: ${TABLE}.chief_complaint ;;
  }

  dimension: chrono_visit_id {
    type: string
    sql: ${TABLE}.chrono_visit_id ;;
  }

  dimension: consent_signature {
    type: string
    sql: ${TABLE}.consent_signature ;;
  }

  dimension: consenter_name {
    type: string
    sql: ${TABLE}.consenter_name ;;
  }

  dimension: consenter_relationship {
    type: string
    sql: ${TABLE}.consenter_relationship ;;
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

  dimension: credit_card_consent {
    type: yesno
    sql: ${TABLE}.credit_card_consent ;;
  }

  dimension: data_use_consent {
    type: yesno
    sql: ${TABLE}.data_use_consent ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: dispatch_queue_id {
    type: number
    sql: ${TABLE}.dispatch_queue_id ;;
  }

  dimension: ehr_id {
    type: string
    sql: ${TABLE}.ehr_id ;;
  }

  dimension: ehr_name {
    type: string
    sql: ${TABLE}.ehr_name ;;
  }

  dimension_group: eta {
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
    sql: ${TABLE}.eta ;;
  }

  dimension: facility {
    type: string
    sql: ${TABLE}.facility ;;
  }

  dimension: market_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.market_id ;;
  }

  dimension_group: on_accepted_eta {
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
    sql: ${TABLE}.on_accepted_eta ;;
  }

  dimension_group: on_route_eta {
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
    sql: ${TABLE}.on_route_eta ;;
  }

  dimension_group: on_scene_etc {
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
    sql: ${TABLE}.on_scene_etc ;;
  }

  dimension: orig_city {
    type: string
    sql: ${TABLE}.orig_city ;;
  }

  dimension: orig_latitude {
    type: number
    sql: ${TABLE}.orig_latitude ;;
  }

  dimension: orig_longitude {
    type: number
    sql: ${TABLE}.orig_longitude ;;
  }

  dimension: orig_state {
    type: string
    sql: ${TABLE}.orig_state ;;
  }

  dimension: orig_street_address_1 {
    type: string
    sql: ${TABLE}.orig_street_address_1 ;;
  }

  dimension: orig_street_address_2 {
    type: string
    sql: ${TABLE}.orig_street_address_2 ;;
  }

  dimension: orig_zipcode {
    type: string
    sql: ${TABLE}.orig_zipcode ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: place_of_service {
    type: string
    sql: ${TABLE}.place_of_service ;;
  }

  dimension_group: prioritized {
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
    sql: ${TABLE}.prioritized_at ;;
  }

  dimension: prioritized_by {
    type: string
    sql: ${TABLE}.prioritized_by ;;
  }

  dimension: priority_note {
    type: string
    sql: ${TABLE}.priority_note ;;
  }

  dimension: privacy_policy_consent {
    type: yesno
    sql: ${TABLE}.privacy_policy_consent ;;
  }

  dimension_group: prompted_survey {
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
    sql: ${TABLE}.prompted_survey_at ;;
  }

  dimension_group: pulled {
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
    sql: ${TABLE}.pulled_at ;;
  }

  dimension_group: pushed {
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
    sql: ${TABLE}.pushed_at ;;
  }

  dimension: request_type {
    type: number
    sql: ${TABLE}.request_type ;;
  }

  dimension: requested_by {
    type: number
    sql: ${TABLE}.requested_by ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension: treatment_consent {
    type: yesno
    sql: ${TABLE}.treatment_consent ;;
  }

  dimension: triage_note_salesforce_id {
    type: string
    sql: ${TABLE}.triage_note_salesforce_id ;;
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

  dimension: use_as_billing_address {
    type: yesno
    sql: ${TABLE}.use_as_billing_address ;;
  }

  dimension_group: verbal_consent {
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
    sql: ${TABLE}.verbal_consent_at ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      ehr_name,
      consenter_name,
      markets.id,
      markets.name,
      markets.provider_group_name,
      markets.short_name,
      credit_cards.count
    ]
  }
}
