view: intraday_shift_teams {
  derived_table: {
    sql: select id, shift_team_id, shift_id, car_id,
created_at   AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' as created_at,
start_time   AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' as start_time,
end_time  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' as end_time,
updated_at   AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' as updated_at
from
(select *,  ROW_NUMBER() OVER(PARTITION BY concat(shift_team_id, date(start_time  AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain' ))
                                ORDER BY updated_at desc)
from public.intraday_shift_teams)lq
where row_number = 1

 ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
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

  dimension_group: end {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.end_time ;;
  }

  measure: max_end {
    type: time
    convert_tz: no
    sql: max(${end_raw}) ;;
  }

  measure: max_start {
    type: time
    convert_tz: no
    sql: max(${start_raw}) ;;
  }

  dimension: shift_id {
    type: number
    sql: ${TABLE}.shift_id ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension_group: start {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.start_time ;;
  }

  dimension_group: updated {
    type: time
    convert_tz: no
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


  dimension_group: now_mountain{
    type: time
    convert_tz: no
    timeframes: [day_of_week_index, week, month, day_of_month, time]
    sql: now() AT TIME ZONE 'US/Mountain' ;;
  }


  measure: max_accepted {
    type: time
    sql: max(${intraday_care_requests.accepted_time}) ;;
  }

  measure: max_etc {
    type: time
    convert_tz: no
    sql: max(${intraday_care_requests.etc_raw}) AT TIME ZONE 'US/Mountain' ;;
  }

  measure:max_etc_or_now
  {
    type: time
    convert_tz: no
    sql: case when ${max_etc_raw} is not null then ${max_etc_raw}
              when now() AT TIME ZONE 'US/Mountain' > ${max_start_raw} then now() AT TIME ZONE 'US/Mountain'+interval '30 minute'
          else ${max_start_raw}+interval '30 minute'
          end;;
  }

  measure: available_time_shift {
    type: number
    value_format: "0.00"
    sql:(EXTRACT(EPOCH FROM ${max_end_raw}-${max_etc_or_now_raw})/3600)-.5;;
  }

  measure: inclusive_shift_length  {
    type: number
    sql: max(
             case when ${markets_intra.name} ='Colorado Springs' then 1.125
              else 1.25 end)
              ;;
  }

  measure: patient_slots{
    type: number
    sql:case when floor(${available_time_shift}/${inclusive_shift_length}) >0 then floor(${available_time_shift}/${inclusive_shift_length})
              else 0 end;;

  }

  measure: sum_available_time_shift {
    type: sum_distinct
    sql_distinct_key: concat(${shift_team_id}, ${start_date});;
    sql: ${available_time_shift};;

  }

  measure: accepted_crs {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.accepted
      value: "yes"
    }
    filters: {
      field: intraday_care_requests.resolved
      value: "no"
    }
  }

  measure: accepted_resolved_crs {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.accepted
      value: "yes"
    }
    filters: {
      field: intraday_care_requests.resolved
      value: "yes"
    }
  }

  measure: accepted_crs_medicaid {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.accepted
      value: "yes"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(MAID)MEDICAID"
    }
    filters: {
      field: intraday_care_requests.resolved
      value: "no"
    }
  }

  measure: accepted_crs_tricare {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.accepted
      value: "yes"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
    filters: {
      field: intraday_care_requests.resolved
      value: "no"
    }
  }


  measure: complete_crs {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.complete
      value: "yes"
    }
  }

  measure: complete_crs_medicaid {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.complete
      value: "yes"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(MAID)MEDICAID"
    }
  }

  measure: complete_crs_tricare {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.complete
      value: "yes"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
  }

  measure: complete_crs_medicaid_tricare {
    type: number
    sql:  ${complete_crs_tricare}+${complete_crs_medicaid};;
  }

  measure: accepted_crs_medicaid_tricare {
    type: number
    sql:  ${accepted_crs_tricare}+${accepted_crs_medicaid};;
  }


  measure: resolved_crs {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: intraday_care_requests.resolved
      value: "yes"
    }
  }

  measure: hours_in_shift{
    type: number
    value_format: "0.0"
    sql: EXTRACT(EPOCH FROM ${max_end_raw}-${max_start_raw})/3600 ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
