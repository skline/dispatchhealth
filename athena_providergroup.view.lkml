view: athena_providergroup {
  sql_table_name: athena.providergroup ;;
  view_label: "Athena Provider Group"

  dimension: __batch_id {
    type: string
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: communicator_brand_name {
    type: string
    sql: ${TABLE}."communicator_brand_name" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."created_by" ;;
  }

  dimension_group: created_datetime {
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

  dimension: medical_group_id {
    type: number
    sql: ${TABLE}."medical_group_id" ;;
  }

  dimension: provider_group_id {
    type: number
    sql: ${TABLE}."provider_group_id" ;;
  }

  dimension: provider_group_name {
    type: string
    sql: ${TABLE}."provider_group_name" ;;
  }

  dimension: provider_group_specialty {
    type: string
    sql: ${TABLE}."provider_group_specialty" ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [provider_group_name, communicator_brand_name]
  }
}
