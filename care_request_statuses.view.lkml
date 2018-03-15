view: care_request_statuses {
  sql_table_name: public.care_request_statuses ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: comment {
    type: string
    sql: ${TABLE}.comment ;;
  }

  dimension: escalated_on_scene_ed {
    type: yesno
    sql: ${comment} = 'Referred - Point of Care: ED'
        OR ${comment} = 'Referred - Point of care: ED';;
  }

  dimension: commentor_id {
    type: number
    sql: ${TABLE}.commentor_id ;;
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
      year, day_of_month
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: created_mountain {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year, day_of_week_index, day_of_month
    ]
    sql: ${TABLE}.created_at - interval '7 hour' ;;
  }

  dimension: created_mtn_decimal {
    type: number
    sql: EXTRACT(HOUR FROM ${created_mountain_raw}) + (EXTRACT(MINUTE FROM ${created_mountain_raw})/60) ;;
  }

  dimension: day_of_week_mountain {
    type: date_day_of_week
    sql: extract(dow FROM  (${created_mountain_raw})) ;;
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

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension_group: started {
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
    sql: ${TABLE}.started_at ;;
  }

  dimension: status_index {
    type: number
    sql: ${TABLE}.status_index ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: today_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: CURRENT_DATE ;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }

  dimension:  same_day_of_week {
    type: yesno
    sql:  ${yesterday_mountain_day_of_week_index} = ${created_mountain_day_of_week_index};;
  }

  dimension: until_today {
    type: yesno
    sql: ${created_mountain_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${created_mountain_day_of_week_index} >= 0 ;;
  }

  dimension: this_week {
    type:  yesno
    sql: ${yesterday_mountain_week} =  ${created_mountain_week};;

  }
  dimension: this_month {
    type:  yesno
    sql: ${yesterday_mountain_month} =  ${created_mountain_month};;
  }

  dimension: month_to_date  {
    type:  yesno
    sql: ${created_mountain_day_of_month} <= ${yesterday_mountain_day_of_month} ;;
  }

  measure: distinct_months {
    type: number
    sql: count(DISTINCT ${created_mountain_month}) ;;
  }


  measure: distinct_days {
    type: number
    sql: count(DISTINCT ${created_mountain_date}) ;;
  }

  measure: distinct_weeks {
    type: number
    sql: count(DISTINCT ${created_mountain_week}) ;;
  }

  measure: daily_average {
    type: number
    sql: ${count_distinct}/${distinct_days} ;;
  }

  measure: weekly_average {
    type: number
    sql: ${count_distinct}/${distinct_weeks} ;;
  }

  measure: monthly_average {
    type: number
    sql: ${count_distinct}/${distinct_months} ;;
  }


  measure: count {
    type: count
    drill_fields: [id, name]
  }

  measure: count_distinct {
    type: number
    sql: count(DISTINCT ${care_request_id});;
  }

  measure: min_day {
    type: date
    sql: min(${created_mountain_date}) ;;
  }

  measure: max_day {
    type: date
    sql:max(${created_mountain_date}) ;;
  }

  measure: min_week {
    type: string
    sql: min(${created_mountain_week}) ;;
  }

  measure: max_week {
    type: string
    sql:max(${created_mountain_week}) ;;
  }
  measure: min_month {
    type: string
    sql: min(${created_mountain_month}) ;;
  }

  measure: max_month {
    type: string
    sql:max(${created_mountain_month}) ;;
  }


  measure: min_max_range_day {
    type: string
    sql:
      case when ${min_week} =  ${yesterday_mountain_week} then ${min_day}::text
      else concat(trim(to_char(current_date - interval '1 day', 'day')), 's ', ${min_day}, ' thru ', ${max_day}) end ;;

    }

  measure: min_max_range_week {
    type: string
    sql:
      case when ${min_week} =  ${yesterday_mountain_week} then concat(${min_day}, ' thru ', ${max_day})
      else concat('Week to date for weeks ', ${min_week}, ' thru ', ${max_week}) end ;;

    }

  measure: min_max_range {
    type: string
    sql: concat(${min_day}, ' thru ', ${max_day});;

  }

  measure: month_percent {
    type: number
    sql:    extract(day from ${max_day})
    /    DATE_PART('days',
        DATE_TRUNC('month', current_date)
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    );;
  }

  measure: monthly_visits_run_rate {
    type: number
    sql: round(${count_distinct}/${month_percent});;
  }

  dimension: days_in_month {
    type: number
    sql:  DATE_PART('days',
        DATE_TRUNC('month', ${created_mountain_date})
        + '1 MONTH'::INTERVAL
        - '1 DAY'::INTERVAL
    ) ;;
  }

  dimension: rolling_30_day {
    type: string
    sql:
    case when ${created_mountain_date} >= current_date - interval '30 day' then 'past 30 days'
    when  ${created_mountain_date} between current_date - interval '60 day' and  current_date - interval '30 day' then 'previous 30 days'
    else null end;;
  }

  measure: projections_diff {
    label: "Diff to budget"
    type: number
    sql: round(${care_request_complete.monthly_visits_run_rate}-${budget_projections_by_market_clone.projected_visits}) ;;
  }

  measure: projections_diff_target {
    label: "Diff to productivity target"
    type: number
    sql: round(${care_request_complete.monthly_visits_run_rate}-${shift_hours_by_day_market_clone.productivity_target}) ;;
  }

  measure: productivity {
    type: number
    sql: round(${count_distinct}/${shift_hours_by_day_market_clone.sum_total_hours}::DECIMAL, 2) ;;
  }
  measure: cost_per_care_status {
    type: number
    sql:  ${ga_adwords_cost_clone.sum_total_adcost}/${count_distinct} ;;
  }



}
