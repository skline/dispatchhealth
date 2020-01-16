view: athenadwh_patientaudit {
  sql_table_name: looker_scratch.athenadwh_patientaudit ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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

  dimension: entity_id {
    type: number
    sql: ${TABLE}."entity_id" ;;
  }

  dimension_group: event_datetime {
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
    sql: ${TABLE}."event_datetime" ;;
  }

  dimension: field_name {
    type: string
    sql: ${TABLE}."field_name" ;;
  }

  dimension: new_value {
    type: string
    sql: ${TABLE}."new_value" ;;
  }

  dimension: old_value {
    type: string
    sql: ${TABLE}."old_value" ;;
  }

  dimension: operation {
    type: string
    sql: ${TABLE}."operation" ;;
  }

  dimension: source_id {
    type: number
    sql: ${TABLE}."source_id" ;;
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

  dimension: username {
    type: string
    sql: ${TABLE}."username" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, field_name, username]
  }
}
