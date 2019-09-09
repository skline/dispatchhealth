view: genesys_conversation_summary {
  sql_table_name: looker_scratch.genesys_conversation_summary ;;

  dimension: abandoned {
    type: number
    sql: ${TABLE}."abandoned" ;;
  }

  dimension: ani {
    type: string
    sql: ${TABLE}."ani" ;;
  }

  dimension: answered {
    type: number
    sql: ${TABLE}."answered" ;;
  }

  dimension: campaignname {
    type: string
    sql: ${TABLE}."campaignname" ;;
  }

  dimension: conversationid {
    type: string
    sql: ${TABLE}."conversationid" ;;
  }

  dimension_group: conversationstarttime {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      day_of_week,
      hour_of_day,
      quarter,
      year
    ]
    sql: ${TABLE}."conversationstarttime" AT TIME ZONE 'UTC';;
  }

  dimension_group: month_placeholder {
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
    sql: '2019-07-05 00:00:00'::timestamp  ;;
  }


  dimension: direction {
    type: string
    sql: ${TABLE}."direction" ;;
  }

  dimension: dnis {
    type: string
    sql: ${TABLE}."dnis" ;;
  }

  dimension: firstacdwaitduration {
    type: number
    sql: ${TABLE}."firstacdwaitduration" ;;
  }

  dimension: mediatype {
    type: string
    sql: ${TABLE}."mediatype" ;;
  }

  dimension: offered {
    type: number
    sql: ${TABLE}."offered" ;;
  }

  dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
  }

  dimension: totalacdwaitduration {
    type: number
    sql: ${TABLE}."totalacdwaitduration" ;;
  }

  dimension: totalagentalertduration {
    type: number
    sql: ${TABLE}."totalagentalertduration" ;;
  }

  dimension: totalagentholdduration {
    type: number
    sql: ${TABLE}."totalagentholdduration" ;;
  }

  dimension: totalagenttalkduration {
    type: number
    sql: ${TABLE}."totalagenttalkduration" ;;
  }

  dimension: totalagentwrapupduration {
    type: number
    sql: ${TABLE}."totalagentwrapupduration" ;;
  }

  dimension: transfered {
    type: number
    sql: ${TABLE}."transfered" ;;
  }

  dimension: long_abandon {
    type: yesno
    sql: ${abandoned} = 1 and ${firstacdwaitduration} > 20000 ;;
  }

  dimension: short_abandon {
    type: yesno
    sql: ${abandoned} = 1 and ${firstacdwaitduration} between 1 and  20000 ;;
  }

  measure: count {
    type: count
    drill_fields: [campaignname, queuename]
  }

  measure: count_distinct {
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key:  ${conversationid};;
  }

  measure: number_abandons {
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: abandoned
      value: "1"
    }
  }

  measure: long_abandons {
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: abandoned
      value: "1"
    }
    filters: {
      field: long_abandon
      value: "yes"
    }
  }

  measure: short_abandons {
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: abandoned
      value: "1"
    }
    filters: {
      field: short_abandon
      value: "yes"
    }
  }

  measure: average_wait_time {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: ${conversationid} ;;
    sql: ${firstacdwaitduration} ;;

  }

  measure: average_wait_time_minutes {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: ${conversationid} ;;
    sql: ${firstacdwaitduration}/1000/60 ;;

  }

  measure: median_wait_time {
    type: median_distinct
    value_format: "0.0"
    sql_distinct_key: ${conversationid} ;;
    sql: ${firstacdwaitduration} ;;
  }

  measure: count_general_inquiry {
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: genesys_conversation_wrapup.wrapupcodename
      value: "General Inquiry"
    }
  }


  measure: count_care_request_disposition {
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: genesys_conversation_wrapup.wrapupcodename
      value: "Care Request Created"
    }
  }

  measure: count_answered {
    type: count_distinct
    sql: ${conversationid} ;;
    sql_distinct_key: ${conversationid}  ;;
    filters: {
      field: answered
      value: "1"
    }
  }

  dimension:  inqueue_time_greater_30{
    type: yesno
    sql: ${firstacdwaitduration}>30000 ;;
  }

  measure:  count_inqeue_time_greater_30s{
    type: count_distinct
    value_format: "0"
    sql_distinct_key: ${conversationid} ;;
    sql: ${conversationid} ;;
    filters: {
      field: inqueue_time_greater_30
      value: "yes"
    }


  }

  dimension: onboard_delay {
    type: number
    sql: EXTRACT(EPOCH FROM (${care_request_flat.accept_mountain_intial_raw} - ${conversationstarttime_raw}));;
  }

  measure: average_onboard_delay {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${conversationid}, ${care_request_flat.care_request_id}) ;;
    sql: ${onboard_delay}/60 ;;
  }

  dimension: anthem_eligible {
    type: yesno
    sql: ${transfered} = 0 and ${markets.name_adj} = 'Richmond' ;;
  }


  #dimension: dispositions_raw {
  #  type: string
  #  sql: array_agg(DISTINCT case when ${genesys_conversation_wrapup.wrapupcodename} = '' then null else ${genesys_conversation_wrapup.wrapupcodename} end ) ;;
  #}

  #measure: dispositions {
  #  type: string
  #  sql: (select array_agg(a) from ${genesys_conversation_wrapup.wrapupcodename} where a is not null);;
  #}



  #dimension: disposition {
  #  type: string
  #  sql: ${dispositions}[1] ;;
  #}
}
