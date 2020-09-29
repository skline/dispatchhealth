view: geneysis_evaluations {
  sql_table_name: looker_scratch.geneysis_evaluations ;;

  dimension: agenthasread {
    type: string
    sql: ${TABLE}."agenthasread" ;;
  }

  dimension: agentid {
    type: string
    sql: ${TABLE}."agentid" ;;
  }

  dimension: agentname {
    type: string
    sql: ${TABLE}."agentname" ;;
  }

  dimension: answerid {
    type: string
    sql: ${TABLE}."answerid" ;;
  }

  dimension: answertext {
    type: string
    sql: ${TABLE}."answertext" ;;
  }

  dimension: answervalue {
    type: number
    sql: ${TABLE}."answervalue" ;;
  }

  dimension: anyfailedkillquestions {
    type: string
    sql: ${TABLE}."anyfailedkillquestions" ;;
  }

  dimension_group: assigneddate {
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
    sql: ${TABLE}."assigneddate" ;;
  }

  dimension_group: changeddate {
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
    sql: ${TABLE}."changeddate" ;;
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

  dimension: evaluationcomments {
    type: string
    sql: ${TABLE}."evaluationcomments" ;;
  }

  dimension: evaluationformid {
    type: string
    sql: ${TABLE}."evaluationformid" ;;
  }

  dimension: evaluationformname {
    type: string
    sql: ${TABLE}."evaluationformname" ;;
  }

  dimension: evaluationid {
    type: string
    sql: ${TABLE}."evaluationid" ;;
  }

  dimension: evaluatorid {
    type: string
    sql: ${TABLE}."evaluatorid" ;;
  }

  dimension: evaluatorname {
    type: string
    sql: ${TABLE}."evaluatorname" ;;
  }

  dimension: failedkillquestion {
    type: string
    sql: ${TABLE}."failedkillquestion" ;;
  }

  dimension: markedna {
    type: string
    sql: ${TABLE}."markedna" ;;
  }

  dimension: maxgrouptotalcriticalscore {
    type: string
    sql: ${TABLE}."maxgrouptotalcriticalscore" ;;
  }

  dimension: maxgrouptotalcriticalscoreunweighted {
    type: number
    sql: ${TABLE}."maxgrouptotalcriticalscoreunweighted" ;;
  }

  dimension: maxgrouptotalscore {
    type: string
    sql: ${TABLE}."maxgrouptotalscore" ;;
  }

  dimension: maxgrouptotalscoreunweighted {
    type: number
    sql: ${TABLE}."maxgrouptotalscoreunweighted" ;;
  }

  dimension: maxquestionscore {
    type: number
    sql: ${TABLE}."maxquestionscore" ;;
  }

  dimension: neverrelease {
    type: string
    sql: ${TABLE}."neverrelease" ;;
  }

  dimension: questiongroupid {
    type: string
    sql: ${TABLE}."questiongroupid" ;;
  }

  dimension: questiongroupmarkedna {
    type: string
    sql: ${TABLE}."questiongroupmarkedna" ;;
  }

  dimension: questiongroupname {
    type: string
    sql: ${TABLE}."questiongroupname" ;;
  }

  dimension: questiongroupweight {
    type: number
    sql: ${TABLE}."questiongroupweight" ;;
  }

  dimension: questionid {
    type: string
    sql: ${TABLE}."questionid" ;;
  }

  dimension: questionscore {
    type: number
    sql: ${TABLE}."questionscore" ;;
  }

  dimension: questionscorecomment {
    type: string
    sql: ${TABLE}."questionscorecomment" ;;
  }

  dimension: questiontext {
    type: string
    sql: ${TABLE}."questiontext" ;;
  }

  dimension: queuename {
    type: string
    sql: ${TABLE}."queuename" ;;
  }

  dimension_group: releasedate {
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
    sql: ${TABLE}."releasedate" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension: totalevaluationcriticalscore {
    type: number
    sql: ${TABLE}."totalevaluationcriticalscore" ;;
  }

  dimension: totalevaluationscore {
    type: number
    sql: ${TABLE}."totalevaluationscore" ;;
  }

  dimension: totalgroupcriticalscore {
    type: string
    sql: ${TABLE}."totalgroupcriticalscore" ;;
  }

  dimension: totalgroupcriticalscoreunweighted {
    type: number
    sql: ${TABLE}."totalgroupcriticalscoreunweighted" ;;
  }

  measure: count {
    type: count
    drill_fields: [agentname, evaluationformname, evaluatorname, questiongroupname, queuename]
  }
}
