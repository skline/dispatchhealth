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
    sql: ${subject} like '%call%' and ${subject} not like '%(phone call/drop-in/email)%' ;;
  }

  dimension: email {
    type: yesno
    sql: ${subject} like '%email%' and ${subject} not like '%(phone call/drop-in/email)%'  ;;
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
    sql_distinct_key: ${account_id} ;;
    sql: ${account_id} ;;
  }

  measure: count_calls {
    type: count_distinct
    sql_distinct_key: ${account_id} ;;
    sql: ${account_id} ;;
    filters: {
      field: call
      value: "yes"
    }
  }

  measure: count_emails {
    type: count_distinct
    sql_distinct_key: ${account_id} ;;
    sql: ${account_id} ;;
    filters: {
      field: email
      value: "yes"
    }
  }

  measure: count_priority_account_activities {
    type: count_distinct
    sql_distinct_key: ${account_id} ;;
    sql: ${account_id} ;;
    filters: {
      field: sf_accounts.priority
      value: "yes"
    }
  }

  measure: count_meetings {
    type: count_distinct
    sql_distinct_key: ${account_id} ;;
    sql: ${account_id} ;;
    filters: {
      field: email
      value: "no"
    }
    filters: {
      field: call
      value: "no"
    }
  }

}
