view: incontact_aggregated_clone {
  sql_table_name: looker_scratch.incontact_aggregated_clone ;;

  dimension: answered {
    type: number
    sql: ${TABLE}.answered ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week_index,
      day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: disposition {
    type: string
    sql: lower(${TABLE}.disposition) ;;
  }

  dimension: inbound {
    type: number
    sql: ${TABLE}.inbound ;;
  }

  dimension: long_abandons {
    type: number
    sql: ${TABLE}.long_abandons ;;
  }

  dimension: prequeue_abandons {
    type: number
    sql: ${TABLE}.prequeue_abandons ;;
  }

  dimension: short_abandons {
    type: number
    sql: ${TABLE}.short_abandons ;;
  }

  dimension: skill {
    type: string
    sql: lower(${TABLE}.skill) ;;
  }

  dimension: mvp {
    type: yesno
    sql: ${skill} like '%mvp%' ;;
  }

  dimension: market_id
  {
    type:  number
    sql:  case when lower(${skill}) like '%den%' then 159
           when lower(${skill}) like '%cos%' then 160
           when lower(${skill}) like '%phx%' then 161
           when lower(${skill}) like '%ric%'  then 164
           when lower(${skill})  like '%las%' then 162
           when lower(${skill})  like '%hou%' then 165
           when lower(${skill})  like '%okla%' or lower(${skill})  like '%okc%' then 166
           else null end ;;
  }

  measure: day_week_modifier {
    type: number
    sql: case when ${date_day_of_week_index} = 0 then .88
              when ${date_day_of_week_index} = 1 then .93
              when ${date_day_of_week_index} = 2 then .99
              when ${date_day_of_week_index} = 3 then .89
              when ${date_day_of_week_index} = 4 then .97
              when ${date_day_of_week_index} = 5 then 1.07
              when ${date_day_of_week_index} = 6 then 1.45
              else 999.0 end
              ;;
  }

  measure: target_possible_intent_calls {
    type: number
    value_format: "0"
    sql: 343.0/${day_week_modifier};;
  }

  measure: diff_possible_intent_calls {
    type: number
    value_format: "0"
    sql: ${possible_intent_calls} -${target_possible_intent_calls} ;;
  }



  measure: sum_long_abandons {
    type: sum_distinct
    label: "Long Abandons"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${long_abandons} ;;
  }

  measure: sum_prequeue_abandons {
    type: sum_distinct
    label: "Prequeue Abandons"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${prequeue_abandons} ;;
  }

  measure: sum_short_abandons {
    type: sum_distinct
    label: "Short Abandons"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${short_abandons} ;;
  }


  measure: sum_answered_calls{
    type: sum_distinct
    label: "Answered Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
  }

  measure: sum_inbound_calls{
    type: sum_distinct
    label: "Inbound Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${inbound} ;;
  }

  measure: sum_short_preq_abandons{
    type: number
    label: "Short & Prequeue Abandons"
    sql: ${sum_prequeue_abandons} +${sum_short_abandons};;
  }




  measure: requesting_care_calls{
    type: sum_distinct
    label: "Created Care Request Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "requesting care,care request created"
    }
  }


  measure: junk_calls{
    type: sum_distinct
    label: "Junk Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "junk"
    }
  }

  measure: general_inquiry_calls{
    type: sum_distinct
    label: "General Inquiry Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "general inquiry"
    }
  }

  measure: booked_calls{
    type: sum_distinct
    label: "Booked Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "booked"
    }
  }

  measure: coordination_calls{
    type: sum_distinct
    label: "Visit Questions or Changes/Test Results/POA Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "visit questions / changes,test results,poa"
    }
  }

  measure: other_calls{
    type: sum_distinct
    label: "Other Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "other,no disposition"
    }
  }


  measure: implied_vm_calls {
    type: number
    sql:  ${sum_inbound_calls} - (${sum_answered_calls}+${sum_short_preq_abandons}+${sum_long_abandons});;
  }

  measure: sum_called_back {
    type: number
    label: "Called Back"
    sql: ${implied_vm_calls}+${sum_long_abandons} ;;
  }

  measure: possible_intent_calls  {
    type: number
    label: "Inbound Demand with Possible Intent"
    sql: ${general_inquiry_calls}+${requesting_care_calls}+${sum_short_preq_abandons}+${booked_calls} ;;
  }

  measure: care_request_created_rate  {
    type: number
    value_format: "0.0%"
    label: "Care Request Created Rate"
    sql: ${requesting_care_calls}/${possible_intent_calls} ;;
  }
  measure: target_care_request_created_rate {
    type: number
    label: "Target Care Request Created Rate"
    value_format: "0.0%"
    sql:  .74;;
  }
  measure: diff_care_request_created_rate {
    type: number
    label: "Diff Care Request Created Rate"
    value_format: "0.0%"
    sql:  ${care_request_created_rate}-${target_care_request_created_rate};;
  }



  measure: answer_rate  {
    type: number
    value_format: "0.0%"
    label: "Answer Rate"
    sql: ${sum_answered_calls}/${sum_inbound_calls} ;;
  }


  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
}
