view: service_lines {
  sql_table_name: public.service_lines ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: existing_pt_appointment_type {
    type: string
    sql: ${TABLE}.existing_patient_appointment_type ->> 'name';;
  }

  dimension: followup_14_30_day {
    type: yesno
    sql: ${TABLE}.followup_14_30_day ;;
  }

  dimension: followup_3_day {
    type: yesno
    sql: ${TABLE}.followup_3_day ;;
  }

  dimension: is_911 {
    type: yesno
    sql: ${TABLE}.is_911 ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: service_line_name_consolidated {
    description: "Similar Service Line categories combined. In addition, request type / channel is considered for '911 Service' and resolved reason is considered for 'Advanced Care'"
    type:  string
    sql:  CASE
      WHEN ${care_requests.request_type} = 'manual_911' OR lower(${name}) = '911 service' THEN '911 Service'
      WHEN lower(${name}) = 'advanced care' OR ${care_request_flat.resolved_to_advanced_care} = 'yes' THEN 'Advanced Care'
      WHEN lower(${name}) in('acute care', 'acute care (hpn)', 'acute care (senior living)', 'asthma education') THEN 'Acute Care'
      WHEN lower(${name}) in('post acute follow up', 'post acute follow up (hpn)') THEN 'Post Acute Follow Up'
      ELSE ${name}
    END
;;

    }

  dimension: new_pt_appointment_type {
    type: string
    sql: ${TABLE}.new_patient_appointment_type ->> 'name';;
  }

  dimension: out_of_network_insurance {
    type: yesno
    sql: ${TABLE}.out_of_network_insurance ;;
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
    drill_fields: [id, name]
  }
}
