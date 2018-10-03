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
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}.note ;;
  }

  dimension_group: note_updated {
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
    sql: ${TABLE}.note_updated_at ;;
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
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.provider_updated_at ;;
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
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  measure: count_distinct {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
