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
      quarter,
      year
    ]
    sql: ${TABLE}."conversationstarttime" ;;
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
    sql: ${abandoned} =1 and ${firstacdwaitduration} > 30000 ;;
  }

  dimension: short_abandon {
    type: yesno
    sql: ${abandoned} =1 and ${firstacdwaitduration} between 2000 and  30000 ;;
  }

  measure: count {
    type: count
    drill_fields: [campaignname, queuename]
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
}
