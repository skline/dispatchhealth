view: cost_projections {
  sql_table_name: looker_scratch.cost_projections ;;

  dimension: campaign_objective {
    type: string
    sql: ${TABLE}.campaign_objective ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: media_tactic {
    type: string
    sql: ${TABLE}.media_tactic ;;
  }

  dimension: month {
    type: string
    sql: ${TABLE}.month ;;
  }

  dimension: partner {
    type: string
    sql: ${TABLE}.partner ;;
  }

  dimension: planned_budget {
    type: number
    sql: ${TABLE}.planned_budget ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_planned_budget{
    type: sum_distinct
    value_format: "$#,##0"
    sql_distinct_key: concat(${campaign_objective}, ${month_month}, ${partner}, ${media_tactic}, ${market}) ;;
    sql: ${planned_budget}  ;;
  }
  dimension: digital {
    type: yesno
    sql: ${media_tactic} = 'digital' ;;
  }

  measure: sum_planned_budget_no_digital{
    type: sum_distinct
    value_format: "$#,##0"
    sql_distinct_key: concat(${campaign_objective}, ${month_month}, ${partner}, ${media_tactic}, ${market}) ;;
    sql: ${planned_budget} ;;
    filters: {
     field: digital
      value: "no"
    }
  }

  dimension_group: month {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: concat(${TABLE}.month, '-01')::date ;;
  }


  dimension_group: yesterday_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }

  measure: month_percent {
    type: number
    sql:

        case when ${month_month} != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }

  measure: complete_visits_run_rate{
    type: number
    sql: round(${care_request_flat.complete_count}/${month_percent});;
  }

  measure: complete_visits_new_run_rate{
    type: number

    sql: round(${care_request_flat.complete_count_new}/${month_percent});;
  }

  measure: cac_total {
    type: number
    value_format: "$0"
    sql: ${sum_planned_budget}/nullif(${complete_visits_run_rate},0) ;;
  }

  measure: cac_new {
    type: number
    value_format: "$0"
    sql: ${sum_planned_budget}/nullif(${complete_visits_new_run_rate},0) ;;
  }

  measure: cac_new_no_digital{
    type: number
    value_format: "$0"
    sql: ${sum_planned_budget_no_digital}/nullif(${complete_visits_new_run_rate},0) ;;
  }



}
