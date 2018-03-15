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
   sql:  round(${sum_total_adcost}/NULLIF(${invoca_clone.count},0)) ;;
 }

  measure: cost_per_care_request {
    type: number
    value_format:"$#;($#)"
    sql:  round(${sum_total_adcost}/NULLIF(${care_requests.count_distinct},0)) ;;
  }

  measure: cost_per_care_complete {
    type: number
    value_format:"$#;($#)"
    sql:  round(${sum_total_adcost}/NULLIF(${care_request_complete.count_distinct}, 0)) ;;
  }


  measure: count {
    type: count
    drill_fields: []
  }
}
