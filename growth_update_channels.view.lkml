view: growth_update_channels {
  sql_table_name: looker_scratch.growth_update_channels ;;

  dimension: identifier_id {
    type: number
    sql: ${TABLE}.identifier_id ;;
  }

  dimension: target {
    type: yesno
    sql:  ${identifier_id} is not null;;
  }

  dimension: identifier_type {
    type: string
    sql: ${TABLE}.identifier_type ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: max_opportunity {
    type: string
    sql: ${TABLE}.max_opportunity ;;
  }

  dimension: partner_name {
    type: string
    sql: ${TABLE}.partner_name ;;
  }

  dimension: partner_type {
    type: string
    sql: ${TABLE}.partner_type ;;
  }
  dimension: partner_sub_type {
    type: string
    sql: ${TABLE}.partner_sub_type ;;
  }

  measure: count {
    type: count
    drill_fields: [partner_name]
  }

  measure: complete_count_coalesce {
    type: number
    sql:  ${care_request_channel_flat.complete_count}+${care_request_payer_flat.complete_count};;
  }

  measure: run_rate_coalesce {
    type: number
    sql:  ${care_request_channel_flat.monthly_visits_run_rate}+${care_request_payer_flat.monthly_visits_run_rate};;
  }

  measure: run_rate_seasonal_coalesce {
    type: number
    sql:  ${care_request_channel_flat.monthly_complete_run_rate_seasonal_adj}+${care_request_payer_flat.monthly_complete_run_rate_seasonal_adj};;
  }

  dimension_group: on_scene_date_coalesce {
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year,
        day_of_week_index,
        day_of_month
      ]
      type: time
    sql: case when ${care_request_channel_flat.on_scene_date} is not null then ${care_request_channel_flat.on_scene_date}
              when ${care_request_payer_flat.on_scene_date} is not null then ${care_request_payer_flat.on_scene_date}
              else null end
    ;;
  }
}
