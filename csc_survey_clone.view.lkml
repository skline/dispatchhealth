view: csc_survey_clone {
  sql_table_name: looker_scratch.csc_survey_clone ;;

  dimension: agent {
    type: string
    sql: ${TABLE}.agent ;;
  }

  dimension: care_and_respect {
    type: number
    sql: ${TABLE}.care_and_respect ;;
  }

  dimension: contact_id {
    type: number
    sql: ${TABLE}.contact_id ;;
  }

  dimension_group: date {
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
    sql: ${TABLE}.date ;;
  }

  dimension: inbound_number {
    type: number
    sql: ${TABLE}.inbound_number ;;
  }

  dimension: rate_your_call_experience {
    type: number
    sql: ${TABLE}.rate_your_call_experience ;;
  }
  measure: average_rate_your_call_experience {
    type:  number
    sql: round(avg(${rate_your_call_experience}),2) ;;
  }
  measure: interaction_score {
    type: number
    sql:  round((avg(${rate_your_call_experience}+${recommend_to_friend}+${care_and_respect}))/3,2);;
  }

  dimension: recommend_to_friend_bool {
    type:  yesno
    sql: ${recommend_to_friend} in(4,5)  ;;
  }

  dimension: 1_or_2_or_3_recommend_to_friend {
    type:  yesno
    sql: ${recommend_to_friend} in(1,2,3)  ;;
  }

  measure: recommend_to_friend_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: {
      field: recommend_to_friend_bool
      value: "yes"
    }
  }
  measure: not_recommend_to_friend_count {
    type: count_distinct
    sql: ${contact_id} ;;
    filters: {
      field: recommend_to_friend_bool
      value: "no"
    }
  }

  measure: aggregate_score {
    type: number
    sql: round((${recommend_to_friend_count}::numeric/${count}::numeric)-(${not_recommend_to_friend_count}::numeric/${count}::numeric),2)*100 ;;
  }



  measure: average_recommend_to_friend {
    type:number
    sql: round(avg(${recommend_to_friend}),2) ;;
  }

  measure: average_care_and_respect {
    type:  number
    sql: round(avg(${care_and_respect}),2) ;;
  }


  dimension: recommend_to_friend {
    type: number
    sql: ${TABLE}.recommend_to_friend ;;
  }

  dimension: time {
    type: string
    sql: ${TABLE}.time ;;
  }

  measure: count {
    type: number
    sql: count(distinct ${contact_id}) ;;

  }
}
