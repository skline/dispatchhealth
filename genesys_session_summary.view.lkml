view: genesys_session_summary {
  sql_table_name: looker_scratch.genesys_session_summary ;;

  dimension: abandoned {
    type: number
    sql: ${TABLE}."abandoned" ;;
  }

  dimension: addressfrom {
    type: string
    sql: ${TABLE}."addressfrom" ;;
  }

  dimension: addressto {
    type: string
    sql: ${TABLE}."addressto" ;;
  }

  dimension: agentanswered {
    type: number
    sql: ${TABLE}."agentanswered" ;;
  }

  dimension: alertnoanswer {
    type: number
    sql: ${TABLE}."alertnoanswer" ;;
  }

  dimension: ani {
    type: string
    sql: ${TABLE}."ani" ;;
  }

  dimension: campaignname {
    type: string
    sql: ${TABLE}."campaignname" ;;
  }

  dimension_group: conversationendtime {
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
    sql: ${TABLE}."conversationendtime" ;;
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

  dimension: disconnecttype {
    type: string
    sql: ${TABLE}."disconnecttype" ;;
  }

  dimension: dnis {
    type: string
    sql: ${TABLE}."dnis" ;;
  }

  dimension: flowout {
    type: number
    sql: ${TABLE}."flowout" ;;
  }

  dimension: holdcount {
    type: number
    sql: ${TABLE}."holdcount" ;;
  }

  dimension: mediatype {
    type: string
    sql: ${TABLE}."mediatype" ;;
  }

  dimension: offered {
    type: number
    sql: ${TABLE}."offered" ;;
  }

  dimension: originatingdirection {
    type: string
    sql: ${TABLE}."originatingdirection" ;;
  }

  dimension: originatingdnis {
    type: string
    sql: ${TABLE}."originatingdnis" ;;
  }

  dimension: participantid {
    type: string
    sql: ${TABLE}."participantid" ;;
  }

  dimension: participantname {
    type: string
    sql: ${TABLE}."participantname" ;;
  }

  dimension: purpose {
    type: string
    sql: ${TABLE}."purpose" ;;
  }

  dimension: queueanswered {
    type: number
    sql: ${TABLE}."queueanswered" ;;
  }

  dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
  }

  dimension: sessioncount {
    type: number
    sql: ${TABLE}."sessioncount" ;;
  }

  dimension: sessionduration {
    type: number
    sql: ${TABLE}."sessionduration" ;;
  }

  dimension_group: sessionendtime {
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
    sql: ${TABLE}."sessionendtime" ;;
  }

  dimension: sessionid {
    type: string
    sql: ${TABLE}."sessionid" ;;
  }

  dimension: sessionindex {
    type: number
    sql: ${TABLE}."sessionindex" ;;
  }

  dimension_group: sessionstarttime {
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
    sql: ${TABLE}."sessionstarttime" ;;
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

  dimension: transferred {
    type: number
    sql: ${TABLE}."transferred" ;;
  }

  dimension: transferto {
    type: string
    sql: ${TABLE}."transferto" ;;
  }

  dimension: transfertopurpose {
    type: string
    sql: ${TABLE}."transfertopurpose" ;;
  }

  dimension: userhandled {
    type: number
    sql: ${TABLE}."userhandled" ;;
  }

  dimension: userid {
    type: string
    sql: ${TABLE}."userid" ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}."username" ;;
  }

  dimension: wrapupcodename {
    type: string
    sql: ${TABLE}."wrapupcodename" ;;
  }

  measure: count {
    type: count
    drill_fields: [campaignname, participantname, queuename, username, wrapupcodename]
  }
}
