view: care_requests_user {
  sql_table_name: public.care_requests ;;

  dimension: id {
    primary_key: yes
    type: number
    alias: [care_request_id]
    sql: ${TABLE}.id ;;
  }

  dimension: channel_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.channel_item_id ;;
  }


  dimension: patient_id {
    type: number
    hidden: yes
    sql: ${TABLE}.patient_id ;;
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

  dimension: chief_complaint {
    type: string
    sql: ${TABLE}.chief_complaint ;;
  }

  dimension: consenter_name {
    type: string
    sql: ${TABLE}.consenter_name ;;
  }

  dimension: consenter_relationship {
    type: string
    sql: ${TABLE}.consenter_relationship ;;
  }

  dimension: resolved_reason_full {
    type: string
    hidden: yes
    sql: coalesce(${care_request_flat.complete_comment}, ${care_request_flat.archive_comment}) ;;
  }

  dimension: primary_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 1)) ;;
  }

  dimension: secondary_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 2)) ;;
  }

  dimension: other_resolved_reason {
    type:  string
    sql: trim(split_part(${resolved_reason_full}, ':', 3)) ;;
  }

  dimension: request_type_id {
    type: number
    hidden: yes
    sql: ${TABLE}.request_type ;;
  }

  dimension: request_type {
    type: string
    sql:  case when ${request_type_id} = 0 then 'phone'
               when ${request_type_id} = 1 then 'manual_911'
               when ${request_type_id} = 2 then 'mobile'
               when ${request_type_id} = 3 then 'web'
               when ${request_type_id} = 4 then 'mobile_android'
               when ${request_type_id} = 5 then 'centura_connect'
               when ${request_type_id} = 6 then 'centura_care_coordinator'
               when ${request_type_id} = 7 then 'orderly'
            else 'other' end;;
  }

  dimension:  complete_visit {
    type: yesno
    hidden: yes
    sql: ${care_request_flat.complete_date} is not null;;
  }

  dimension:  referred_point_of_care {
    type: yesno
    hidden: yes
    sql: ${care_request_flat.complete_comment} like '%Referred - Point of Care%';;
  }

  dimension:  billable_est {
    type: yesno
    hidden: yes
    sql: ${referred_point_of_care} or ${care_requests.complete_visit};;
  }

  measure: count_distinct {
    description: "Count of distinct care requests"
    type: number
    sql: count(distinct ${id}) ;;
  }

  measure: count_billable_est {
    type: count_distinct
    description: "Count of completed care requests OR on-scene escalations"
    sql: ${id} ;;
    filters: {
      field: billable_est
      value: "yes"
    }
  }


}
