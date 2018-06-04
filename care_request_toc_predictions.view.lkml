view: care_request_toc_predictions {
  sql_table_name: public.care_request_toc_predictions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age_index {
    type: number
    sql: ${TABLE}.age_index ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
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

  dimension: toc_prediction_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.toc_prediction_id ;;
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

  measure: count {
    type: count
    drill_fields: [id, toc_predictions.id]
  }
}
