view: predicted_on_scene_time {
  sql_table_name: looker_scratch.predicted_on_scene_time ;;

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: mins_on_scene_predicted {
    type: number
    sql: ${TABLE}.mins_on_scene_predicted ;;
  }

  dimension: etc_predicted_binned {
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170]
    style:interval
    sql: ${mins_on_scene_predicted} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
