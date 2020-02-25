view: sf_activities {
  sql_table_name: looker_scratch.sf_activities ;;

  dimension: inside_sales{
    type: yesno
    sql: lower(${assigned}) in ('syeda abbas', 'matthew callman') ;;
  }
  dimension: cem {
    type: yesno
    sql:  lower(${assigned}) not in ('syeda abbas', 'matthew callman', 'melanie plaksin', 'karrie austin escobedo', 'christine greimann','kendra tinsley');;
  }

  dimension: call {
    type: yesno
    sql: (${subject} like '%call%' or  ${task_type} ='call') and ${subject} not like '%email%' and ${task_type} !='email' and (${result} != 'need to contact' or ${result} is null);;
  }

  dimension: actual_activity {
    type: yesno
    sql: ${result} != 'need to contact' or ${result} is null   ;;
  }

  dimension: call_answered {
    type: yesno
    sql: ${call} and ${result} in('connected', 'booked a meeting');;
  }

  dimension: call_booked_a_meeting{
    type: yesno
    sql: ${call} and ${result} in('booked a meeting');;
  }

  dimension: email {
    type: yesno
    sql:( ${subject} like '%email%' or ${task_type} ='email') and ${subject} not like '%(phone call/drop-in/email)%'  ;;
  }

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension: activity_id {
    type: string
    sql: ${TABLE}."activity_id" ;;
  }

  dimension: assigned {
    type: string
    sql: ${TABLE}."assigned" ;;
  }


  dimension_group: start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      time
    ]
    sql: ${TABLE}."start_date" ;;
  }

  dimension: visits_after_activity {
    type: yesno
    sql: ${start_date} <= ${care_request_flat.on_scene_date} ;;
  }

  measure: complete_count_after_activity {
    type: count_distinct
    sql: ${care_request_flat.care_request_id} ;;
    filters: {
      field: care_request_flat.complete
      value: "yes"
    }
    filters: {
      field: visits_after_activity
      value: "yes"
    }
  }

  dimension_group: end {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      time
    ]
    sql: ${TABLE}."end_date" ;;
  }

  dimension: result {
    type: string
    sql: lower(${TABLE}."result") ;;
  }

  dimension: comments {
    type: string
    sql: lower(${TABLE}."comments") ;;
  }


  dimension: subject {
    type: string
    sql: lower(${TABLE}."subject") ;;
  }

  dimension: task_type {
    type: string
    sql: lower(${TABLE}."task_type") ;;
  }

  dimension: lead_type {
    type: string
    sql: lower(${TABLE}."lead_type") ;;
  }


  dimension: task_bool {
    type: yesno
    sql: ${TABLE}."task_bool" = true ;;
  }


  measure: count_activities {
    label: "Activities"
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: actual_activity
      value: "yes"
    }
  }

  measure: count_activities_accounts {
    label: "Activities (Unique Accounts)"
    type: count_distinct
    sql_distinct_key: ${sf_accounts.account_id} ;;
    sql:${sf_accounts.account_id} ;;
    filters: {
      field: actual_activity
      value: "yes"
    }
  }

  measure: count_calls {
    label: "Calls"
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: call
      value: "yes"
    }
  }

  measure: count_calls_accounts{
    label: "Calls (Unique Accounts)"
    type: count_distinct
    sql_distinct_key:  ${sf_accounts.account_id} ;;
    sql:  ${sf_accounts.account_id};;
    filters: {
      field: call
      value: "yes"
    }
  }


  measure: percent_calls_made{
    label: "Calls Made Percent"

    type: number
    value_format: "00.0%"
    sql: case when ${count_calls_intended} = 0 then 0 else
    ${count_calls}::float /${count_calls_intended}::float end;;
  }

  measure: percent_calls_made_accounts{
    label: "Calls Made Percent (Unique Accounts)"

    type: number
    value_format: "00.0%"
    sql: case when ${count_calls_intended_accounts} = 0 then 0 else
      ${count_calls_accounts}::float /${count_calls_intended_accounts}::float end;;
  }


  measure: percent_calls_answered{
    label: "Answered Calls Percent"

    type: number
    value_format: "00.0%"
    sql: case when ${count_calls} = 0 then 0 else
    ${count_calls_answered}::float /${count_calls}::float end;;
  }

  measure: percent_calls_answered_accounts{
    label: "Answered Calls Percent (Unique Accounts)"

    type: number
    value_format: "00.0%"
    sql: case when ${count_calls_accounts} = 0 then 0 else
      ${count_calls_answered_accounts}::float /${count_calls_accounts}::float end;;
  }

  measure: percent_meetings_booked{
    label: "Meetings Booked Percent"
    type: number
    value_format: "00.0%"
    sql: case when ${count_calls} = 0 then 0 else
    ${count_calls_booked_a_meeting}::float /${count_calls}::float end;;
  }

  measure: percent_meetings_booked_accounts{
    label: "Meetings Booked Percent (Unique Accounts)"
    type: number
    value_format: "00.0%"
    sql: case when ${count_calls_accounts} = 0 then 0 else
      ${count_calls_booked_a_meeting_accounts}::float /${count_calls_accounts}::float end;;
  }

  measure: percent_meetings_booked_answered{
    label: "Meetings Booked (Answered) Percent"

    type: number
    value_format: "00.0%"
    sql:  case when ${count_calls_answered} = 0 then 0 else
    ${count_calls_booked_a_meeting}::float /${count_calls_answered}::float end;;
  }


  measure: percent_meetings_booked_answered_accounts{
    label: "Meetings Booked (Answered) Percent (Unique Accounts)"
    type: number
    value_format: "00.0%"
    sql:  case when ${count_calls_answered_accounts} = 0 then 0 else
      ${count_calls_booked_a_meeting_accounts}::float /${count_calls_answered_accounts}::float end;;
  }


  measure: count_calls_answered {
    label: "Answered Calls"
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: call
      value: "yes"
    }
    filters: {
      field: call_answered
      value: "yes"
    }
  }


  measure: count_calls_answered_accounts {
    label: "Answered Calls (Unique Accounts)"
    type: count_distinct
    sql_distinct_key: ${sf_accounts.account_id} ;;
    sql: ${sf_accounts.account_id} ;;
    filters: {
      field: call
      value: "yes"
    }
    filters: {
      field: call_answered
      value: "yes"
    }
  }

  measure: count_calls_booked_a_meeting {
    label: "Booked Meetings"
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: call
      value: "yes"
    }
    filters: {
      field: call_booked_a_meeting
      value: "yes"
    }
  }

  measure: count_calls_booked_a_meeting_accounts {
    label: "Booked Meetings (Unique Accounts)"
    type: count_distinct
    sql_distinct_key: ${sf_accounts.account_id} ;;
    sql: ${sf_accounts.account_id} ;;
    filters: {
      field: call
      value: "yes"
    }
    filters: {
      field: call_booked_a_meeting
      value: "yes"
    }
  }

  measure: count_calls_intended {
    label: "Planned Calls"
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: task_type
      value: "call"
    }
  }

  measure: count_calls_intended_accounts {
    label: "Planned Calls  (Unique Accounts)"
    type: count_distinct
    sql_distinct_key: ${sf_accounts.account_id} ;;
    sql: ${sf_accounts.account_id} ;;
    filters: {
      field: task_type
      value: "call"
    }
  }

  measure: count_emails {
    label: "Emails"
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: email
      value: "yes"
    }
  }

  measure: count_emails_accounts {
    type: count_distinct
    label: "Emails (Unique Accounts)"
    sql_distinct_key: ${sf_accounts.account_id} ;;
    sql: ${sf_accounts.account_id} ;;
    filters: {
      field: email
      value: "yes"
    }
  }

  measure: count_priority_account_activities {
    label: "Priority Account Activities"

    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: sf_accounts.priority
      value: "yes"
    }
    filters: {
      field: actual_activity
      value: "yes"
    }
  }

  measure: count_priority_account_activities_accounts {
    label: "Priority Account Activities (Unique Accounts)"
    type: count_distinct
    sql_distinct_key: ${sf_accounts.account_id} ;;
    sql:${sf_accounts.account_id} ;;
    filters: {
      field: sf_accounts.priority
      value: "yes"
    }
    filters: {
      field: actual_activity
      value: "yes"
    }
  }

  measure: count_meetings {
    label: "Count In-person Activity"
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: email
      value: "no"
    }
    filters: {
      field: call
      value: "no"
    }
    filters: {
      field: actual_activity
      value: "yes"
    }
  }


  measure: count_meetings_unique_accounts {
    label: "Count In-person Activity (Unique Accounts)"
    type: count_distinct
    sql_distinct_key: ${sf_accounts.account_id} ;;
    sql: ${sf_accounts.account_id} ;;
    filters: {
      field: email
      value: "no"
    }
    filters: {
      field: call
      value: "no"
    }
    filters: {
      field: actual_activity
      value: "yes"
    }
  }
}
