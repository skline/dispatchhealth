view: sf_activities {
  sql_table_name: looker_scratch.sf_activities ;;

  dimension: inside_sales{
    type: yesno
    sql: lower(${assigned}) in ('syeda abbas', 'matthew callman') ;;
  }
  dimension: cem {
    type: yesno
    sql:  lower(${assigned}) not in ('syeda abbas', 'matthew callman', 'melanie plaksin', 'karrie austin escobedo', 'christine greimann');;
  }

  dimension: call {
    type: yesno
    sql: (${subject} like '%call%' or  ${task_type} ='call') and ${subject} not like '%email%' and ${task_type} !='email' and ${result} != 'need to contact';;
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
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: actual_activity
      value: "yes"
    }
  }

  measure: count_calls {
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: call
      value: "yes"
    }
  }


  measure: count_calls_answered {
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

  measure: count_calls_booked_a_meeting {
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

  measure: count_calls_intended {
    label: "Count Planned Calls"
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: task_type
      value: "call"
    }
  }

  measure: count_emails {
    type: count_distinct
    sql_distinct_key: ${activity_id} ;;
    sql: ${activity_id} ;;
    filters: {
      field: email
      value: "yes"
    }
  }

  measure: count_priority_account_activities {
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

}
