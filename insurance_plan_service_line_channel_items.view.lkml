view: insurance_plan_service_line_channel_items {
  sql_table_name: public.insurance_plan_service_line_channel_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: channel_item_id {
    type: number
    sql: ${TABLE}."channel_item_id" ;;
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

  dimension: insurance_plan_service_line_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."insurance_plan_service_line_id" ;;
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
    drill_fields: [id, insurance_plan_service_lines.id]
  }
}
