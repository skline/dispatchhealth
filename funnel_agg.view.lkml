# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: funnel_agg {
  derived_table: {
    sql_trigger_value:  select count(*) from public.care_requests where care_requests.created_at > current_date - interval '2 day';;
    indexes: ["created_date", "name_adj"]
    explore_source: care_requests {
      column: name_adj { field: markets.name_adj }
      column: created_date { field: care_request_flat.created_date }
      column: created_day_of_week { field: care_request_flat.created_day_of_week }
      column: cpr_market { field: markets.cpr_market }
      column: care_request_count { field: care_request_flat.care_request_count }
      column: count_distinct_bottom_funnel_care_requests { field: care_request_flat.count_distinct_bottom_funnel_care_requests }
      column: count_complete_same_day { field: care_request_flat.count_complete_same_day }
      column: count_complete_overflow { field: care_request_flat.count_complete_overflow }
      column: limbo_overflow { field: care_request_flat.limbo_overflow }
      column: limbo_non_overflow { field: care_request_flat.limbo_non_overflow }
      column: count_resolved_overflow { field: care_request_flat.count_resolved_overflow }
      column: lwbs_minus_overflow { field: care_request_flat.lwbs_minus_overflow }
      column: no_answer_no_show_count_minus_overflow { field: care_request_flat.no_answer_no_show_count_minus_overflow }
      column: booked_shaping_placeholder_resolved_count_minus_overflow { field: care_request_flat.booked_shaping_placeholder_resolved_count_minus_overflow }
      column: clinical_service_not_offered_minus_overflow { field: care_request_flat.clinical_service_not_offered_minus_overflow }
      column: covid_resolved_minus_overflow { field: care_request_flat.covid_resolved_minus_overflow }
      column: insurance_resolved_minus_overflow { field: care_request_flat.insurance_resolved_minus_overflow }
      column: poa_resolved_minus_overflow { field: care_request_flat.poa_resolved_minus_overflow }
      column: zipcode_resolved_minus_overflow { field: care_request_flat.zipcode_resolved_minus_overflow }
      column: cancelled_by_patient_other_resolved_minus_overflow { field: care_request_flat.cancelled_by_patient_other_resolved_minus_overflow }
      column: insufficient_information_resolved_minus_overflow { field: care_request_flat.insufficient_information_resolved_minus_overflow }
      column: resolved_other_count_bottom_funnel { field: care_request_flat.resolved_other_count_bottom_funnel }
      column: all_lost { field: care_request_flat.total_lost }
      column: all_lost_above_baseline { field: care_request_flat.total_lost_above_baseline }
      column: booked_shaping_lost { field: care_request_flat.booked_shaping_lost }
      column: overflow_lost { field: care_request_flat.overflow_lost }
      column: limbo_overflow_lost { field: care_request_flat.limbo_overflow_lost }
      column: lwbs_lost { field: care_request_flat.lwbs_lost }
      column: non_screened_escalated_phone_count { field: care_request_flat.non_screened_escalated_phone_count }
      column: screened_escalated_phone_count { field: care_request_flat.screened_escalated_phone_count }
      column: screened_escalated_ed_phone_count { field: care_request_flat.screened_escalated_ed_phone_count }
      column: overflow_complete_rate { field: care_request_flat.overflow_complete_rate }
      column: non_screened_escalated_phone_count_ed { field: care_request_flat.non_screened_escalated_phone_count_ed }
      filters: {
        field: care_request_flat.created_date
        value: "365 days ago for 365 days"
      }
      filters: {
        field: service_lines.name
        value: "-COVID-19 Facility Testing"
      }
    }
  }
  dimension: name_adj {
    description: "Market name where WMFR is included as part of Denver"
  }
  dimension: created_date {
    description: "The local date/time that the care request was created."
    type: date
  }

  dimension: created_day_of_week {
    type: string
  }
  dimension: cpr_market {
    label: "Markets Cpr Market (Yes / No)"
    description: "Flag to identify CPR markets (hard-coded)"
    type: yesno
  }
  dimension: care_request_count {
    type: number
  }
  dimension: count_distinct_bottom_funnel_care_requests {
    description: "Count of distinct care requests w/o phone screened"
    type: number
  }
  dimension: count_complete_same_day {
    description: "Count of completed care requests OR on-scene escalations (Same Day)"
    type: number
  }
  dimension: count_complete_overflow {
    description: "Count of completed care requests OR on-scene escalations (Not Same Day)"
    type: number
  }
  dimension: limbo_overflow {
    type: number
  }
  dimension: limbo_non_overflow {
    type: number
  }
  dimension: count_resolved_overflow {
    description: "Count of completed care requests OR on-scene escalations (Not Same Day)"
    type: number
  }
  dimension: lwbs_minus_overflow {
    type: number
  }

  measure: total_lwbs_minus_overflow {
    type: sum_distinct
    sql: ${lwbs_minus_overflow} ;;
    sql_distinct_key: concat(${created_date}, ${name_adj}) ;;
  }


  dimension: no_answer_no_show_count_minus_overflow {
    type: number
  }
  dimension: booked_shaping_placeholder_resolved_count_minus_overflow {
    description: "Care requests resolved for booked, shaping or placeholder"
    type: number
  }

  measure: total_booked_shaping_placeholder_resolved_count_minus_overflow {
    type: sum_distinct
    sql: ${booked_shaping_placeholder_resolved_count_minus_overflow} ;;
    sql_distinct_key: concat(${created_date}, ${name_adj}) ;;
  }


  dimension: clinical_service_not_offered_minus_overflow {
    type: number
  }
  dimension: covid_resolved_minus_overflow {
    type: number
  }
  dimension: insurance_resolved_minus_overflow {
    type: number
  }
  dimension: poa_resolved_minus_overflow {
    type: number
  }
  dimension: zipcode_resolved_minus_overflow {
    type: number
  }
  dimension: cancelled_by_patient_other_resolved_minus_overflow {
    type: number
  }
  dimension: insufficient_information_resolved_minus_overflow {
    type: number
  }
  dimension: resolved_other_count_bottom_funnel {
    type: number
  }
  dimension: all_lost {
    label: "Care Request Flat Total Lost Due to Capacity Constraints"
    value_format: "#,##0"
    type: number
  }
  dimension: all_lost_above_baseline {
    label: "Care Request Flat Total Lost Due to Capacity Constraints Above Baseline (2.5%)"
    value_format: "#,##0"
    type: number
  }

  measure: total_all_lost{
    type: sum_distinct
    value_format: "0"
    sql: ${all_lost} ;;
    sql_distinct_key: concat(${created_date}, ${name_adj}) ;;
  }

  measure: total_all_lost_above_baseline{
    type: sum_distinct
    sql: ${all_lost_above_baseline} ;;
    sql_distinct_key: concat(${created_date}, ${name_adj}) ;;
  }

  dimension: booked_shaping_lost {
    value_format: "#,##0"
    type: number
  }

  measure: total_booked_shaping_lost{
    type: sum_distinct
    sql: ${booked_shaping_lost} ;;
    sql_distinct_key: concat(${created_date}, ${name_adj}) ;;
  }

  dimension: overflow_lost {
    value_format: "#,##0"
    type: number
  }
  dimension: limbo_overflow_lost {
    value_format: "#,##0"
    type: number
  }
  dimension: lwbs_lost {
    value_format: "#,##0"
    type: number
  }

  measure: total_lwbs_lost{
    type: sum_distinct
    sql: ${lwbs_lost} ;;
    sql_distinct_key: concat(${created_date}, ${name_adj}) ;;
  }


  dimension: non_screened_escalated_phone_count {
    description: "Care requests NOT secondary screened and escalated over the phone"
    type: number
  }
  dimension: screened_escalated_phone_count {
    description: "Care requests secondary screened and escalated over the phone"
    type: number
  }
  dimension: screened_escalated_ed_phone_count {
    description: "Care requests secondary screened and escalated over the phone ED"
    type: number
  }
  dimension: overflow_complete_rate {
    value_format: "0%"
    type: number
  }
  dimension: non_screened_escalated_phone_count_ed {
    description: "Care requests NOT secondary screened and escalated over the phone to the ED"
    type: number
  }

  #added


  dimension: all_overflow {
    type: number
    sql: ${limbo_overflow}+${count_resolved_overflow}+${count_complete_overflow} ;;
  }

  dimension: daily_overflow_percent {
    type: number
    sql: case when ${productivity_agg.complete_count_no_arm_advanced} >0 then ${all_overflow}::float/${productivity_agg.complete_count_no_arm_advanced} else 0 end;;

  }

  measure: total_all_overflow {
    type: sum_distinct
    sql: ${all_overflow} ;;
    sql_distinct_key: concat(${created_date}, ${name_adj}) ;;
  }

  measure: overflow_percent {
    type: number
    value_format: "0%"
    sql: case when ${productivity_agg.total_complete_count_no_arm_advanced} >0 then ${total_all_overflow}::float/${productivity_agg.total_complete_count_no_arm_advanced} else 0 end;;
  }

  measure: booked_shaping_percent {
    type: number
    value_format: "0%"
    sql:  ${total_booked_shaping_placeholder_resolved_count_minus_overflow}::float/${productivity_agg.total_complete_count_no_arm_advanced};;
  }

  measure: same_day_lwbs_percent {
    type: number
    value_format: "0%"
    sql:  ${total_lwbs_minus_overflow}::float/${productivity_agg.total_complete_count_no_arm_advanced};;
  }


  measure: inefficiency_index{
    type: number
    value_format: "0.00"
    sql: (${overflow_percent}-.2)*(.7-${productivity_agg.total_productivity})*100 ;;
  }

}
