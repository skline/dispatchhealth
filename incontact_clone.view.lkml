view: incontact_clone {
  sql_table_name: looker_scratch.incontact_clone ;;

  dimension: contact_id {
    type: number
    sql: ${TABLE}.contact_id ;;
  }

  dimension: contact_time_sec {
    type: number
    sql: ${TABLE}.contact_time_sec ;;
  }


  dimension_group: today_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date;;
  }

  dimension_group: yesterday_mountain{
    type: time
    timeframes: [day_of_week_index, week, month, day_of_month]
    sql: current_date - interval '1 day';;
  }

  dimension: month_to_date  {
    type:  yesno
    sql: ${start_day_of_month} < ${today_mountain_day_of_month}  ;;
  }

  dimension: until_today {
    type: yesno
    sql: ${start_day_of_week_index} <=  ${yesterday_mountain_day_of_week_index} AND ${start_day_of_week_index} >= 0 ;;
  }

  dimension: inqueuetime {
    type: number

    sql: ${TABLE}.inqueuetime ;;
  }

   measure: avg_inqueuetime {
    label: "Average InQueue Time (s)"
    type: average
    value_format: "#.0"
    sql: ${inqueuetime} ;;
  }
  dimension: abandon_time {
    type: number
    sql: ${TABLE}.abandon_time ;;
  }

  measure: avg_abandontime {
    label: "Average Abandon Time (s)"
    type: average
    value_format: "#.0"
    sql: ${abandon_time} ;;
  }

  dimension: contact_type {
    type: string
    sql: ${TABLE}.contact_type ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }

  dimension: duration {
    type: number
    sql: coalesce(${TABLE}.duration,0) ;;
  }

  dimension_group: end {
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.end_time ;;
  }

  dimension: end_time_raw {
    type: string
    sql: ${TABLE}.end_time ;;
  }

  dimension: start_time_raw {
    type: string
    sql: ${TABLE}.start_time ;;
  }

  dimension: from_number {
    type: string
    sql:   ${TABLE}.from_number;;
  }

  dimension: skll_name {
    type: string
    sql: ${TABLE}.skll_name ;;
  }


  dimension: mvp {
    type: yesno
    sql: ${campaign}='Care Phone' and lower(${skll_name}) like '%mvp%'  ;;
  }

  dimension_group: start {
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      day_of_month,
      day_of_week_index
    ]
    sql: ${TABLE}.start_time ;;
  }

  dimension: talk_time_sec {
    type: number
    sql: coalesce(${TABLE}.talk_time_sec,0) ;;
  }

  dimension: agent_name {
    type: string
    sql: ${TABLE}.agent_name ;;
  }

  dimension: market_id
  {
    type:  number
    sql:  case when lower(${skll_name}) like '%den%' then 159
           when lower(${skll_name}) like '%cos%' then 160
           when lower(${skll_name}) like '%phx%' then 161
           when lower(${skll_name}) like '%ric%'  then 164
           when lower(${skll_name})  like '%las%' then 162
           when lower(${skll_name})  like '%hou%' then 165
          when lower(${skll_name})  like '%okla%' or lower(${skll_name})  like '%okc%' then 166
           else null end ;;
  }
dimension: skill_category {
  type:  string
  sql: case
    when lower(${skll_name}) like '%voicemail%' or lower(${skll_name}) like '% vm%' then 'Voicemail'
    when lower(${skll_name}) like '%outbound%' then 'Outbound'
    else ${campaign} end ;;
}

dimension: abandons {
  type: number
  sql: ${TABLE}.abandons ;;
}

  dimension: answered {
    type: number
    sql: ${TABLE}.answered ;;
  }
  dimension: call_back {
    type: number
    sql: ${TABLE}.call_backs ;;
  }
  dimension: handled {
    type: number
    sql: ${answered} + ${call_back} ;;
  }
  dimension: master_contact_id {
    type: number
    sql: ${TABLE}.master_contact_id ;;
  }
  dimension: prequeue_abandons {
    type: number
    sql: ${TABLE}.prequeue_abandons ;;
  }


  measure: count {
    type: count
    drill_fields: [skll_name]
  }
  measure: count_distinct {
    label: "Inbound Contacts"
    type: number
    sql:count(distinct ${master_contact_id}) ;;
  }

  measure: close_rate {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat.complete_count}::float/${count_distinct}::float));;

  }

  measure: cr_create_rate {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat.care_request_count}::float/${count_distinct}::float));;

  }

  measure: cr_create_rate_exact {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_exact.care_request_count}::float/${count_distinct}::float));;

  }

  measure: close_rate_exact {
    type: number
    value_format: "0.0%"
    sql: ((${care_request_flat_exact.complete_count}::float/${count_distinct}::float));;

  }


  dimension: phone_call  {
    type: yesno
    sql: ${campaign} not in ('Care Electronic') ;;
  }

  measure: count_distinct_calls {
    label: "Inbound Calls"
    type: number
    sql:count(distinct case when (${campaign} != 'Care Electronic')  then ${master_contact_id} else null end);;

  }

  measure: count_distinct_live_answers {
    label: "Live Answers"
    type: number
    sql:  count(distinct case when (${answered}=1 and ${campaign} != 'VM')  then ${master_contact_id} else null end);;

  }

  measure: count_distinct_handled {
    label: "Handles"
    type: number
    sql:  count(distinct case when (${answered}=1 or ${call_back}=1 or ${campaign} = 'VM') then ${master_contact_id} else null end);;

  }

  measure: count_distinct_voicemails {
    type: number
    label: "Voicemails"
    sql:  count(distinct case when ${campaign} = 'VM' then ${master_contact_id} else null end);;
  }


  measure: count_distinct_abandoned {
    type: number
    label: "Total Abandons"
    sql:  count(distinct case when (${abandons}=1 or ${prequeue_abandons}=1) and ${campaign} !='VM'  then ${master_contact_id} else null end);;
  }

  measure: count_distinct_long_abandoned {
    type: number
    label: "Long Abandons (>20s)"
    sql:  count(distinct case when ((${abandons}=1 or ${prequeue_abandons}=1) and ${campaign} !='VM') and ${abandon_time} > 20  then ${master_contact_id} else null end);;
  }

  measure: live_answer_rate {
    type: number
    value_format: "#.0\%"
    sql: ((${count_distinct_live_answers}::float/${count_distinct_calls}::float))*100;;
  }

  measure: handled_rate {
    type: number
    value_format: "#.0\%"
    sql: ((${count_distinct_handled}::float/${count_distinct_calls}::float))*100;;
  }

  measure: abandoned_rate {
    type: number
    label: "Total Abandon Rate"
    value_format: "#.0\%"
    sql: ((${count_distinct_abandoned}::float/${count_distinct_calls}::float))*100;;
  }

  measure: long_abandoned_rate {
    type: number
    label: "Long Abandon Rate (>20s)"
    value_format: "#.0\%"
    sql: ((${count_distinct_long_abandoned}::float/${count_distinct_calls}::float))*100;;
  }



dimension: care_line {
  type: yesno
  sql: (${campaign} in('Care Phone', 'VM') and ${contact_type} != 'Transfer to Agent') or ${invoca_clone.call_record_ikd} is not null;;
}


  measure: count_distinct_phone_number {
    type: number
    sql:count(distinct ${from_number}) ;;
  }


  measure: count_distinct_answers_phone_number {
    type: number
    sql:count(distinct case when ${talk_time_sec}>0  then ${from_number} else null end) ;;
  }

  measure:  wait_time{
    type: number
    sql: ${contact_time_sec} - ${talk_time_sec} ;;
  }
  measure:  average_wait_time{
    label: "Average Wait Time (s)"
    type: average_distinct
    sql_distinct_key: concat(${master_contact_id}, ${start_time}, ${skll_name}) ;;
    sql: ${contact_time_sec} - ${talk_time_sec} ;;
  }

  measure:  average_wait_time_r{
    type: number
    sql: round(${average_wait_time}) ;;
    }
}
