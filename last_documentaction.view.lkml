view: last_documentaction {
  view_label: "Athena Last Document Action (DEV)"
  derived_table: {
    sql:
    SELECT
    da.*,
    prv.provider_first_name,
    prv.provider_last_name,
    prv.provider_type,
    prv.provider_type_name,
    CASE
        WHEN UPPER(prv.provider_type_name) = 'MEDICAL ASSISTANT (MA)' THEN 'Medical Assistant'
        WHEN UPPER(prv.provider_type_name) IN ('ADVANCED PRACTICE REGISTERED NURSE', 'CERTIFIED PHYSICIAN ASSISTANT',
                                               'NURSE PRACTITIONER SUPERVISING(NP S)','PHYSICIAN ASSISTANT (PA)',
                                               'PHYSICIAN ASSISTANT SUPERVISING','REGISTERED NURSE (RN)') THEN 'Advanced Practice Provider'
        WHEN UPPER(prv.provider_type_name) IN ('DOCTOR OF OSTEOPATHY (DO)', 'MD') THEN 'Medical Doctor'
        WHEN UPPER(prv.provider_type_name) = 'EQUIPMENT' THEN 'Equipment'
        ELSE NULL END AS provider_category
    FROM athena.documentaction da
    INNER JOIN (
        SELECT
            document_id,
            MAX(document_action_id) AS document_action_id,
            MAX(created_datetime) AS last_created
        FROM athena.documentaction
        GROUP BY 1
        ORDER BY 1 DESC) AS dacurr
        ON da.document_action_id = dacurr.document_action_id
    LEFT JOIN athena.provider prv
        ON UPPER(da.created_by) = UPPER(prv.scheduling_name) ;;

    sql_trigger_value:  SELECT MAX(document_id) FROM athena.documentaction where created_at > current_date - interval '2 day';;
    indexes: ["document_id"]
  }

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension: action {
    type: string
    sql: ${TABLE}."action" ;;
  }

  dimension: action_group {
    type: string
    sql: ${TABLE}."action_group" ;;
  }

  dimension: assigned_to {
    type: string
    sql: ${TABLE}."assigned_to" ;;
  }

  dimension_group: created_at {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

  dimension: order_to_close_hours {
    description: "Number of hours from order created to closed"
    type: number
    hidden: yes
    value_format: "0.0"
    sql: (EXTRACT(EPOCH FROM ${created_raw}) - EXTRACT(EPOCH FROM ${document_orders.created_raw})) / 3600 ;;
  }

  measure: average_hours_to_close {
    description: "The average number of hours to close the order"
    type: average_distinct
    value_format: "0.0"
    sql: ${order_to_close_hours} ;;
    filters: [
      status: "CLOSED"
    ]
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."created_by" ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}."deleted_by" ;;
  }

  dimension_group: deleted {
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
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: document_action_id {
    type: number
    hidden: yes
    sql: ${TABLE}."document_action_id" ;;
  }

  dimension: document_category {
    type: string
    hidden: yes
    sql: ${TABLE}."document_category" ;;
  }

  dimension: document_class {
    type: string
    sql: ${TABLE}."document_class" ;;
  }

  dimension: document_error_reason {
    type: string
    sql: ${TABLE}."document_error_reason" ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}."document_id" ;;
  }

  dimension: document_pre_class {
    type: string
    hidden: yes
    sql: ${TABLE}."document_pre_class" ;;
  }

  dimension: document_sub_class {
    type: string
    sql: ${TABLE}."document_sub_class" ;;
  }

  dimension: erroryn {
    type: string
    sql: ${TABLE}."erroryn" ;;
  }

  dimension: mobile {
    type: string
    hidden: yes
    sql: ${TABLE}."mobile" ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}."note" ;;
  }

  dimension: provider_type_name {
    type: string
    description: "The provider type by whom the record was closed"
    sql: ${TABLE}.provider_type_name ;;
  }

  dimension: provider_category {
    type: string
    description: "The category (MA, APP, MD) of the provider by whom the record was closed"
    sql: ${TABLE}.provider_category ;;
  }

  dimension_group: patient_notified_datetime {
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
    sql: ${TABLE}."patient_notified_datetime" ;;
  }

  dimension: priority {
    type: string
    sql: ${TABLE}."priority" ;;
  }

  dimension: send_fax_unique_id {
    type: string
    sql: ${TABLE}."send_fax_unique_id" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."status" ;;
  }

  dimension: system_key {
    type: string
    sql: ${TABLE}."system_key" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."updated_at" ;;
  }

}
