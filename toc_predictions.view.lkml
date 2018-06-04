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
