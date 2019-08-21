view: secondary_screenings {
  sql_table_name: public.secondary_screenings ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: note {
    type: string
    sql: ${TABLE}.note ;;
  }

  dimension: empty_note {
    type: yesno
    sql: ${note} IS NULL ;;
  }

  measure: count_missing_note {
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: empty_note
      value: "yes"
    }
  }

  dimension_group: note_updated {
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
    sql: ${TABLE}.note_updated_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: note_updater_id {
    type: number
    sql: ${TABLE}.note_updater_id ;;
  }

  dimension: provider_id {
    type: number
    sql: ${TABLE}.provider_id ;;
  }

  dimension_group: provider_updated {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.provider_updated_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: provider_updater_id {
    type: number
    sql: ${TABLE}.provider_updater_id ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  measure: count_distinct {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  measure: count_screened_escalated_phone {
    description: "Count of care requests that had secondary screening and that were escalated over the phone"
    type: count_distinct
    sql: ${care_request_id} ;;
    filters: {
      field: care_request_flat.escalated_on_phone
      value: "yes"
    }
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
