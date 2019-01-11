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
      day_of_week,
      day_of_month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension_group: today_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date;;
  }

  dimension: month_to_date  {
    type:  yesno
    sql: ${date_day_of_month} < ${today_mountain_day_of_month}  ;;
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
           when lower(${skill})  like 'spr%' or trim(lower(${skill}))  like '%spi%' then 168
           when lower(${skill})  like '%tac%'  then 170
          when lower(${skill})  like '%dal%'  then 169

           else null end ;;
  }


  measure: target_possible_intent_calls {
    type: sum_distinct
    label: "Target Inbound Calls with Possible Intent (December)"
    value_format: "0"
    sql_distinct_key: concat(${date_date}, ${market_id}) ;;
    sql: ${goal_inbound_calls_dec.goal_inbound_calls_dec};;
  }

  measure: diff_possible_intent_calls {
    label: "Diff vs Target Inbound Calls with Possible Intent"
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

  measure: count_distinct_days {
    type: count_distinct
    #sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${date_date} ;;
  }

  measure: sum_mvp_inbound_calls{
    type: sum_distinct
    label: "Inbound MVP Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${inbound} ;;
    filters: {
      field: mvp
      value: "yes"
    }
  }

  measure: sum_non_mvp_inbound_calls{
    type: sum_distinct
    label: "Inbound Non-MVP Calls"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${inbound} ;;
    filters: {
      field: mvp
      value: "no"
    }
  }

  measure: mvp_percent {
    type: number
    value_format: "0.0%"
    sql: ${sum_mvp_inbound_calls}/nullif(${sum_inbound_calls},0) ;;
  }

  measure: sum_short_preq_abandons{
    type: number
    label: "Short & Prequeue Abandons"
    sql: ${sum_prequeue_abandons} +${sum_short_abandons};;
  }




  measure: requesting_care_calls{
    type: sum_distinct
    label: "Created Care Request Answers"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "requesting care,care request created"
    }
  }


  measure: junk_calls{
    type: sum_distinct
    label: "Junk Answers"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "junk"
    }
  }

  measure: general_inquiry_calls{
    type: sum_distinct
    label: "General Inquiry Answers"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "general inquiry"
    }
  }

  measure: booked_calls{
    type: sum_distinct
    label: "Booked Answers"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "booked"
    }
  }

  measure: coordination_calls{
    type: sum_distinct
    label: "Visit Questions or Changes/Test Results/POA Answers"
    sql_distinct_key: concat(${date_raw}, ${skill}, ${campaign_name}, ${disposition}) ;;
    sql: ${answered} ;;
    filters: {
      field: disposition
      value: "visit questions / changes,test results,poa"
    }
  }

  measure: other_calls{
    type: sum_distinct
    label: "Other Answers"
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
    label: "Inbound Calls with Possible Intent"
    sql: ${general_inquiry_calls}+${requesting_care_calls}+${sum_short_abandons}+${booked_calls}+${sum_called_back} ;;
  }

  measure: calls_intent_no_cr {
    value_format: "0"
    type: number
    sql: .3*${general_inquiry_calls}+.25*${sum_called_back}+.2*${sum_short_abandons} ;;
  }

  measure: care_request_created_rate  {
    type: number
    value_format: "0.0%"
    label: "Care Request Created Rate"
    sql: ${requesting_care_calls}/nullif(${possible_intent_calls},0) ;;
  }
  measure: target_care_request_created_rate {
    type: number
    label: "Target Care Request Created Rate"
    value_format: "0.0%"
    sql:  .72;;
  }
  measure: diff_care_request_created_rate {
    type: number
    label: "Diff vs Target Care Request Created Rate"
    value_format: "0.0%"
    sql:  ${care_request_created_rate}-${target_care_request_created_rate};;
  }

  measure: target_care_request_created {
    type: number
    label: "Target Care Request Created (December)"
    value_format: "0"
    sql:  ${target_care_request_created_rate}*${target_possible_intent_calls};;
  }


  measure: diff_care_request_created {
    type: number
    label: "Diff Care Request Created"
    value_format: "0"
    sql:  ${requesting_care_calls} -${target_care_request_created};;
  }




  measure: answer_rate  {
    type: number
    value_format: "0.0%"
    label: "Answer Rate"
    sql: ${sum_answered_calls}/nullif(${sum_inbound_calls},0) ;;
  }


  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
}
