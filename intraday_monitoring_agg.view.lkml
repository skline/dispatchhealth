view: intraday_monitoring_agg {
    derived_table: {
      explore_source: intraday_monitoring {
        column: created_date {}
        column: created_hour {}
        column: market {}
        column: complete_est {}
        column: productivity_est {}
        column: complete_count { field: care_request_flat.complete_count }
        column: diff_to_actual {}
        filters: {
          field: intraday_monitoring.created_date
          value: "before 0 days ago"
        }
        filters: {
          field: cars.arm_car
          value: "No"
        }
      }
    }
    dimension: created_date {
      type: date
    }
    dimension: created_hour {
      type: number
    }
    dimension: market {}
    dimension: complete_est {
      type: number
    }
    dimension: productivity_est {
      type: number
    }
    dimension: complete_count {
      type: number
    }
    dimension: diff_to_actual {
      type: number
    }

    dimension: abs_diff_to_actual {
      type: number
      sql: abs(${diff_to_actual}) ;;
    }

    dimension: percent_diff_to_actual {
      type: number
      sql: case when ${complete_count}=0 then 0
    else ${diff_to_actual}::float/${complete_count}::float end ;;
    }

  dimension: percent_abs_diff_to_actual {
    type: number
    sql: case when ${complete_count}=0 then 0
    else ${abs_diff_to_actual}::float/${complete_count}::float end ;;
  }

    measure: avg_diff_to_actual {
      type: average_distinct
      value_format: "0.0"
      sql_distinct_key: concat(${created_date}, ${created_hour}, ${market}) ;;
      sql: ${diff_to_actual} ;;
    }

  measure: avg_abs_diff_to_actual {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${created_date}, ${created_hour}, ${market}) ;;
    sql: ${abs_diff_to_actual} ;;
  }

  measure: avg_complete_count {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${created_date}, ${created_hour}, ${market}) ;;
    sql: ${complete_count} ;;
  }

  measure: avg_complete_est {
    type: average_distinct
    value_format: "0.0"
    sql_distinct_key: concat(${created_date}, ${created_hour}, ${market}) ;;
    sql: ${complete_est} ;;
  }


  measure: avg_diff_to_actual_percent {
    type: number
    value_format: "0.0%"
    sql: case when ${avg_complete_count}=0 then 0
    else ${avg_diff_to_actual}::float/${avg_complete_count}::float end
 ;;
  }

  measure: avg_abs_diff_to_actual_percent {
    type: average_distinct
    value_format: "0.0%"
    sql_distinct_key: concat(${created_date}, ${created_hour}, ${market}) ;;
    sql: ${percent_abs_diff_to_actual} ;;
  }
  }
