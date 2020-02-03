view: sf_accounts {
  sql_table_name: looker_scratch.sf_accounts ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension: account_name {
    type: string
    sql: ${TABLE}."account_name" ;;
  }

  dimension: channel_items_id {
    type: number
    sql: ${TABLE}."channel_items_id" ;;
  }

  dimension: channel_type {
    type: string
    sql: ${TABLE}."channel_type" ;;
  }

  dimension_group: last_activity {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."last_activity" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: neighborhood {
    type: string
    sql: ${TABLE}."neighborhood" ;;
  }
  dimension: priority {
    type: yesno
    sql: ${priority_account_timestamp_raw} >=  date_trunc('month', now())::date - 70 ;;
  }

  dimension_group: priority_account_timestamp {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."priority_account_timestamp" ;;
  }

  dimension: priority_action {
    type: string
    sql: ${TABLE}."priority_action" ;;
  }

  dimension: priority_action_set {
    type: yesno
    sql: ${priority_action} is not null ;;
  }

  dimension: quadrant {
    type: string
    sql: ${TABLE}."quadrant" ;;
  }

  measure: count {
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
  }

  measure: count_priority {
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
    filters:  {
      field: priority
      value: "yes"
    }
  }

  measure: count_priority_action_set {
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
    filters:  {
      field: priority
      value: "yes"
    }
    filters:  {
      field: priority_action_set
      value: "yes"
    }
  }
}
