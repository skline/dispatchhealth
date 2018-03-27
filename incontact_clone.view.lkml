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

  dimension: contact_type {
    type: string
    sql: ${TABLE}.contact_type ;;
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
    sql:   concat('+1', ${TABLE}.from_number::text) ;;
  }

  dimension: skll_name {
    type: string
    sql: ${TABLE}.skll_name ;;
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
      hour_of_day
    ]
    sql: ${TABLE}.start_time ;;
  }

  dimension: talk_time_sec {
    type: number
    sql: coalesce(${TABLE}.talk_time_sec,0) ;;
  }

  dimension: to_number {
    type: string
    sql: ${TABLE}.to_number ;;
  }

  dimension: market_id
  {
    type:  number
    sql:  case when lower(${skll_name}) like '%den%' then 159
           when lower(${skll_name}) like '%cos%' then 160
           when lower(${skll_name}) like '%phx%' then 161
           when lower(${skll_name}) like '%ric%'  then 164
           when lower(${skll_name})  like '%las%' then 162
           else null end ;;
  }
dimension: skill_category {
  type:  string
  sql: case when lower(${skll_name}) like '%care%' then 'Care Line'
     when lower(${skll_name}) like '%partner%' then 'Partner Line'
     when lower(${skll_name}) like '%backline%' then 'Backline'
     when lower(${skll_name}) like '%medical%' then 'Medical'
     when lower(${skll_name}) like '%outbound%' then 'Outbound'
     when lower(${skll_name}) like '%voicemail%' or ${skll_name} like '%VM%' then 'Voicemail'
     else 'Other' end ;;
}

  measure: count {
    type: count
    drill_fields: [skll_name]
  }
  measure: count_distinct {
    label: "distinct calls pressed IVR"
    type: number
    sql:count(distinct ${contact_id}) ;;
  }

  measure: count_distinct_answers {
    type: number
    sql:count(distinct case when ${talk_time_sec}>0  then ${contact_id} else null end) ;;
  }

  measure: count_distinct_voicemails {
    type: number
    sql:  count(distinct case when ${skill_category} = 'Voicemail' then ${contact_id} else null end);;
  }

  measure: count_distinct_abandoned {
    type: number
    sql:  count(distinct case when ${talk_time_sec}=0  then ${contact_id} else null end);;
  }

  measure: answer_rate {
    type: number
    sql: 1.0 -(${count_distinct_abandoned}::float/${count_distinct}::float);;
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
    type: average_distinct
    sql_distinct_key: concat(${contact_id}, ${start_time}, ${skll_name}) ;;
    sql: ${contact_time_sec} - ${talk_time_sec} ;;
  }

  measure:  average_wait_time_r{
    type: number
    sql: round(${average_wait_time}) ;;
    }
}
