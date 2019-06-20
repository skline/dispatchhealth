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
      sql: ${diff_to_actual}::float/${complete_count}::float ;;
    }

  dimension: percent_abs_diff_to_actual {
    type: number
    sql: ${abs_diff_to_actual}::float/${complete_count}::float ;;
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

  measure: avg_diff_to_actual_percent {
    type: average_distinct
    value_format: "0.0%"
    sql_distinct_key: concat(${created_date}, ${created_hour}, ${market}) ;;
    sql: ${percent_diff_to_actual} ;;
  }

  measure: avg_abs_diff_to_actual_percent {
    type: average_distinct
    value_format: "0.0%"
    sql_distinct_key: concat(${created_date}, ${created_hour}, ${market}) ;;
    sql: ${percent_abs_diff_to_actual} ;;
  }
  }
