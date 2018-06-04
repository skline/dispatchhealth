view: toc_predictions {
  sql_table_name: public.toc_predictions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age_index {
    type: number
    sql: ${TABLE}.age_index ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: final_weight_index {
    type: number
    sql: ${TABLE}.final_weight_index ;;
  }

  dimension: health_partners_channel {
    type: yesno
    sql: ${TABLE}.health_partners_channel ;;
  }

  dimension: high_risk_assessment {
    type: yesno
    sql: ${TABLE}.high_risk_assessment ;;
  }

  dimension: medicare {
    type: yesno
    sql: ${TABLE}.medicare ;;
  }

  dimension: mins_on_scene_predicted {
    type: number
    sql: ${TABLE}.mins_on_scene_predicted ;;
  }

  dimension: new_patient {
    type: yesno
    sql: ${TABLE}.new_patient ;;
  }

  dimension: phone {
    type: yesno
    sql: ${TABLE}.phone ;;
  }

  dimension: pos_home {
    type: yesno
    sql: ${TABLE}.pos_home ;;
  }

  dimension: pos_work {
    type: yesno
    sql: ${TABLE}.pos_work ;;
  }

  dimension: risk_score_index {
    type: number
    sql: ${TABLE}.risk_score_index ;;
  }

  dimension: sha {
    type: string
    hidden: yes
    sql: ${TABLE}.sha ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: toc_actual_minus_pred {
    type: number
    description: "Actual on-scene time minus predicted on-scene time"
    # sql: ${care_requests.on_scene_etc_mountain_time_of_day} -  ;;
    sql: ${care_request_flat.on_scene_time_minutes} - ${mins_on_scene_predicted} ;;
  }

  dimension: toc_actual_minus_50 {
    type: number
    description: "Actual on-scene time minus predicted on-scene time"
    # sql: ${care_requests.on_scene_etc_mountain_time_of_day} -  ;;
    sql: ${care_request_flat.on_scene_time_minutes} - 50 ;;
  }

  parameter: toc_tier_bucket_size {
    default_value: "20"
    type: number
  }

  dimension: dynamic_time_diff_tier {
    type: number
    sql: FLOOR(${toc_actual_minus_pred} / {% parameter toc_tier_bucket_size %})
      * {% parameter toc_tier_bucket_size %} ;;
  }

  dimension: real_minus_pred_tier {
    type: tier
    tiers: [-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60]
    style: integer
    sql: ${toc_actual_minus_pred} ;;
  }

  dimension: real_minus_50_tier {
    type: tier
    tiers: [-60,-50,-40,-30,-20,-10,0,10,20,30,40,50,60]
    style: integer
    sql: ${toc_actual_minus_50} ;;
  }

  measure: avg_mins_on_scene_predicted {
    type: average
    value_format: "0.00"
    sql: ${mins_on_scene_predicted} ;;
  }

  measure: sum_mins_on_scene_predicted {
    type: sum
    value_format: "0.00"
    sql: ${mins_on_scene_predicted} ;;
  }

  measure: count {
    type: count
    drill_fields: [id, care_request_toc_predictions.count]
  }
}
