view: ga_adwords_cost_clone {
  sql_table_name: looker_scratch.ga_adwords_cost_clone ;;

  dimension: adclicks {
    type: number
    sql: ${TABLE}.adclicks ;;
  }
  measure: sum_total_adclicks {
    type: sum_distinct
    sql_distinct_key: concat(${date_date}, ${adwordscampaignid}, ${adwordscreativeid},${admatchtype}, ${keyword}, ${adwordsadgroupid}) ;;
    sql: ${TABLE}.adclicks  ;;
  }

  dimension: adcost {
    type: number
    value_format:"$#;($#)"
    sql: ${TABLE}.adcost ;;
  }

  measure: sum_total_adcost {
    type: sum_distinct
    value_format:"$#;($#)"
    sql_distinct_key: concat(${date_date}, ${adwordscampaignid}, ${adwordscreativeid}, ${admatchtype}, ${keyword},  ${adwordsadgroupid}) ;;
    sql: ${TABLE}.adcost  ;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [date, day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }
  measure: month_percent {
    type: number
    sql:

        case when ${date_month} != ${yesterday_mountain_month} then 1
        else
            extract(day from ${yesterday_mountain_date})
          /    DATE_PART('days',
              DATE_TRUNC('month', ${yesterday_mountain_date})
              + '1 MONTH'::INTERVAL
              - '1 DAY'::INTERVAL
          ) end;;
  }


  measure: ad_cost_monthly_run_rate {
    type: number
    value_format:"$#;($#)"
    sql: ${sum_total_adcost}/${month_percent} ;;
    }


  dimension: admatchtype {
    type: string
    sql: ${TABLE}.admatchtype ;;
  }

  dimension: adwordscampaignid {
    type: number
    value_format_name: id
    sql: ${TABLE}.adwordscampaignid ;;
  }

  dimension: adwordscreativeid {
    type: number
    value_format_name: id
    sql: ${TABLE}.adwordscreativeid ;;
  }

  dimension_group: date {
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
    sql: ${TABLE}.date ;;
  }

  dimension: adwordsadgroupid {
    type: string
    sql: ${TABLE}.adwordsadgroupid ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }
  measure: sum_total_impressions {
          type: sum_distinct
          sql_distinct_key: concat(${date_date}, ${adwordscampaignid}, ${adwordscreativeid},${admatchtype},  ${keyword},  ${adwordsadgroupid}) ;;
          sql: ${TABLE}.impressions  ;;
 }
  dimension: keyword {
    type: string
    sql: ${TABLE}.keyword ;;
  }
 measure: cost_per_call {
   type: number
   value_format:"$#;($#)"
   sql:  ${sum_total_adcost}/NULLIF(${invoca_clone.count},0) ;;
 }

  measure: cost_per_care_request {
    type: number
    value_format:"$#;($#)"
    sql:  ${sum_total_adcost}/NULLIF(${ga_adwords_stats_clone.total_care_requests},0) ;;
  }

  measure: cost_per_care_complete {
    type: number
    value_format:"$#;($#)"
    sql:  ${sum_total_adcost}/NULLIF(${ga_adwords_stats_clone.total_complete}, 0) ;;
  }

  measure: cost_per_clicks {
    type: number
    value_format:"$#;($#)"
    sql:  ${sum_total_adcost}/NULLIF(${sum_total_adclicks}, 0) ;;
  }

  measure: cost_per_impressions {
    type: number
    value_format:"$#.00;($#).00"
    sql:  ${sum_total_adcost}/NULLIF(${sum_total_impressions}, 5) ;;
  }

  measure: cost_per_sessions {
    type: number
    value_format:"$#;($#)"
    sql:  ${sum_total_adcost}/NULLIF(${ga_adwords_stats_clone.distinct_sessions}, 0) ;;
  }



  measure: count {
    type: count
    drill_fields: []
  }
}
