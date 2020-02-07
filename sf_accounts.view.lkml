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

  dimension: channel_items_id_is_set {
    type: yesno
    sql:  ${channel_items_id} is not null;;
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

  dimension: parent_account_id {
    type: string
    sql: ${TABLE}."parent_account_id" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."phone" ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}."address" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension: zipcode {
    type: string
    sql: ${TABLE}."zipcode" ;;
  }

  dimension: record_type {
    type: string
    sql: ${TABLE}."record_type" ;;
  }

  dimension: type {
    label: "Type (Prospect etc.)"
    type: string
    sql: ${TABLE}."type" ;;
  }

  dimension: website {
    type: string
    sql: ${TABLE}."website" ;;
  }

  dimension: projected_volume {
    type: number
    sql: ${TABLE}."projected_volume" ;;
  }

  dimension: number_of_beds {
    type: number
    sql: ${TABLE}."number_of_beds" ;;
  }

  dimension: collaborative_agreement {
    type: yesno
    sql: ${TABLE}."collaborative_agreement" is true ;;
  }

  dimension_group: id_campaign {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."id_campaign" ;;
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
  measure: count_priority_dashboard_id_set {
    type: count_distinct
    sql: ${account_id} ;;
    sql_distinct_key: ${account_id} ;;
    filters:  {
      field: priority
      value: "yes"
    }
    filters:  {
      field: channel_items_id_is_set
      value: "yes"
    }
  }
}