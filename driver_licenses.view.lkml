view: driver_licenses {
  sql_table_name: public.driver_licenses ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: license {
    type: string
    sql: ${TABLE}.license ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension_group: updated {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: id_captured_flag {
    type: yesno
    sql: ${updated_date} = ${care_request_flat.complete_date}::date;;
  }

  measure: count_ids_captured {
    type: count_distinct
    sql: ${patient_id} ;;
    filters: {
      field: id_captured_flag
      value: "yes"
    }
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: count_patients {
    type: count_distinct
    sql: ${patient_id} ;;
  }
}
