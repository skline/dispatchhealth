view: invoca_clone {
  sql_table_name: looker_scratch.invoca_clone ;;

  dimension: adset_name {
    type: string
    sql: ${TABLE}.adset_name ;;
  }

  dimension: adwords_click_id {
    type: string
    sql: ${TABLE}.adwords_click_id ;;
  }

  dimension: age_range_append {
    type: number
    sql: ${TABLE}.age_range_append ;;
  }

  dimension: analytics_vistor_id {
    type: string
    sql: ${TABLE}.analytics_vistor_id ;;
  }

  dimension: call_record_ikd {
    type: string
    sql: ${TABLE}.call_record_ikd ;;
  }

  dimension: call_result {
    type: string
    sql: ${TABLE}.call_result ;;
  }

  dimension: caller_id {
    type: string
    sql: ${TABLE}.caller_id;;
  }

  dimension: carrier_append {
    type: string
    sql: ${TABLE}.carrier_append ;;
  }

  dimension: children_append {
    type: string
    sql: ${TABLE}.children_append ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_append {
    type: string
    sql: ${TABLE}.city_append ;;
  }

  dimension: country_append {
    type: string
    sql: ${TABLE}.country_append ;;
  }

  dimension: destination_phone_number {
    type: string
    sql: ${TABLE}.destination_phone_number ;;
  }

  dimension: display_name_append {
    type: string
    sql: ${TABLE}.display_name_append ;;
  }

  dimension: education_append {
    type: string
    sql: ${TABLE}.education_append ;;
  }

  dimension: end_call {
    type: string
    sql: ${TABLE}.end_call ;;
  }

  dimension: first_name_append {
    type: string
    sql: ${TABLE}.first_name_append ;;
  }

  dimension: gender_append {
    type: string
    sql: ${TABLE}.gender_append ;;
  }

  dimension: high_net_worth_append {
    type: string
    sql: ${TABLE}.high_net_worth_append ;;
  }

  dimension: home_owner_append {
    type: string
    sql: ${TABLE}.home_owner_append ;;
  }

  dimension: home_value_append {
    type: string
    sql: ${TABLE}.home_value_append ;;
  }

  dimension: househould_income_append {
    type: string
    sql: ${TABLE}.househould_income_append ;;
  }

  dimension: is_prepaid_append {
    type: string
    sql: ${TABLE}.is_prepaid_append ;;
  }

  dimension: keywords {
    type: string
    sql: ${TABLE}.keywords ;;
  }

  dimension: last_name_append {
    type: string
    sql: ${TABLE}.last_name_append ;;
  }

  dimension: length_residence_append {
    type: string
    sql: ${TABLE}.length_residence_append ;;
  }

  dimension: line_type_append {
    type: string
    sql: ${TABLE}.line_type_append ;;
  }

  dimension: linked_email_append {
    type: string
    sql: ${TABLE}.linked_email_append ;;
  }

  dimension: martial_status_append {
    type: string
    sql: ${TABLE}.martial_status_append ;;
  }

  dimension: media_type {
    type: string
    sql: ${TABLE}.media_type ;;
  }

  dimension: occupation_append {
    type: string
    sql: ${TABLE}.occupation_append ;;
  }

  dimension: phone_type {
    type: string
    sql: ${TABLE}.phone_type ;;
  }

  dimension: placement {
    type: string
    sql: ${TABLE}.placement ;;
  }

  dimension: pool_type {
    type: string
    sql: ${TABLE}.pool_type ;;
  }

  dimension: primary_email_append {
    type: string
    sql: ${TABLE}.primary_email_append ;;
  }

  dimension: profile {
    type: string
    sql: ${TABLE}.profile ;;
  }

  dimension: profile_campaign {
    type: string
    sql: ${TABLE}.profile_campaign ;;
  }

  dimension: promo_number_description {
    type: string
    sql: ${TABLE}.promo_number_description ;;
  }

  dimension: promo_number_id {
    type: number
    sql: ${TABLE}.promo_number_id ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: repeat_caller {
    type: string
    sql: ${TABLE}.repeat_caller ;;
  }

  dimension: search_type {
    type: string
    sql: ${TABLE}.search_type ;;
  }

  dimension: source {
    type: number
    sql: ${TABLE}.source ;;
  }

  dimension_group: start {
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
    sql: ${TABLE}.start_time ;;
  }

  dimension_group: start_coalese {
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
    sql: coalesce(${start_raw}, ${incontact_clone.start_raw})  ;;
  }


  dimension: state_append {
    type: string
    sql: ${TABLE}.state_append ;;
  }

  dimension: street_address_append {
    type: string
    sql: ${TABLE}.street_address_append ;;
  }

  dimension: total_duration {
    type: string
    sql: ${TABLE}.total_duration ;;
  }

  dimension: total_duration_seconds {
    type: number
    sql:EXTRACT(EPOCH FROM ${total_duration});;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: utm_campaign {
    type: string
    sql: ${TABLE}.utm_campaign ;;
  }

  dimension: utm_content {
    type: string
    sql: ${TABLE}.utm_content ;;
  }

  dimension: utm_medium {
    type: string
    sql: ${TABLE}.utm_medium ;;
  }

  dimension: utm_source {
    type: string
    sql: ${TABLE}.utm_source ;;
  }

  dimension: utm_term {
    type: string
    sql: ${TABLE}.utm_term ;;
  }

  dimension: zip_append {
    type: number
    sql: ${TABLE}.zip_append ;;
  }

  dimension: start_time_raw {
    type: string
    sql: ${TABLE}.start_time ;;
  }

  dimension: utm_source_and_utm_medium {
    type: string
    sql: concat(${utm_source}, ': ', ${utm_medium}) ;;
  }

  dimension: market_id
  {
    type:  number
    sql:  case when lower(${profile_campaign}) like '%den%' then 159
     when lower(${profile_campaign}) like '%colo%' then 160
     when lower(${profile_campaign}) like '%phoe%' then 161
     when lower(${profile_campaign}) like '%ric%'  then 164
     when lower(${profile_campaign})  like '%las%' then 162
     when lower(${profile_campaign})  like '%hou%' then 165
     else null end ;;
  }
  dimension: self_report {
    type: yesno
    sql: ${utm_medium} = 'self report' ;;
  }

  dimension: incontact_only {
    type: yesno
    sql: ${incontact_clone.contact_id} is not null and ${call_record_ikd} is null ;;
  }

  dimension: mvp {
    type: yesno
    sql: (${incontact_clone.mvp})
         OR lower(${profile_campaign}) like '%direct%';;
  }

  measure: count {
    label: "Distinct Invoca Calls"
    type: count_distinct
    sql_distinct_key:  ${call_record_ikd};;
    sql: ${call_record_ikd} ;;
    filters: {
      field: self_report
      value: "no"
    }
  }

  dimension: incontact_invoca_concat {
    type: string
    sql: concat(${call_record_ikd}, ${incontact_clone.master_contact_id}) ;;
  }

  measure: count_calls {
    label: "Distinct Calls"
    type: count_distinct
    sql_distinct_key:  ${incontact_invoca_concat};;
    sql: ${incontact_invoca_concat} ;;
    filters: {
      field: self_report
      value: "no"
    }
  }

  measure: count_distinct_number {
    label: "Distinct Invoca Calls Unique Numbers"
    type: count_distinct
    sql_distinct_key:  ${call_record_ikd};;
    sql:${caller_id} ;;
    filters: {
      field: self_report
      value: "no"
    }
  }



  measure: avg_invoca_duration {
    label: "average invoca duration seconds"
    type: average_distinct
    sql_distinct_key:  ${call_record_ikd};;
    sql: round(${total_duration_seconds});;
    filters: {
      field: self_report
      value: "no"
    }
  }
  measure: avg_invoca_duration_r{
    label: "average invoca duration seconds r"
    type: average_distinct
    sql_distinct_key:  ${call_record_ikd};;
    sql: round(${avg_invoca_duration}) ;;
    filters: {
      field: self_report
      value: "no"
    }

    }

  dimension: market_or_promo  {
    type: string
    sql: case when ${markets.name} is not null then  ${markets.name} else ${promo_number_description} end;;
  }
  dimension: direct_bool {
    type:  yesno
    sql:  ${profile_campaign} like '% Di%' ;;

  }

  measure: calls_run_rate{
    type: number
    value_format: "#,##0"
    sql: ${count}/${care_request_flat.month_percent} ;;
  }
  dimension: sem {
    type: yesno
    sql: (${utm_source} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${utm_medium} in('cpc', 'paid search')) or lower(${utm_medium}) like '%google%' or lower(${utm_medium}) like '%bing ad extension%'
 ;;
  }

  dimension: local_listings {
    type: yesno
    sql:  lower(${promo_number_description}) like '%local listings%'

      ;;
  }


}
