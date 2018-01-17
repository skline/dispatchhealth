view: channel_dimensions {
  sql_table_name: jasperdb.channel_dimensions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: dashboard_channel_item_id {
    type: number
    sql: ${TABLE}.dashboard_channel_item_id ;;
  }

  dimension: main_type {
    type: string
    sql: ${TABLE}.main_type ;;
  }

  dimension: organization {
    type: string
    sql: ${TABLE}.organization ;;
  }

  dimension: sub_type {
    type: string
    sql: ${TABLE}.sub_type ;;
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

  measure: count {
    type: count
    drill_fields: [id]
  }
}
