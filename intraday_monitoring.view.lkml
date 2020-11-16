view: intraday_monitoring {
  sql_table_name: looker_scratch.intraday_monitoring ;;

  dimension: complete_est {
    type: number
    sql: ${TABLE}.complete_est ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year, day_of_week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_date ;;
  }

  dimension: created_hour {
    type: number
    sql: ${TABLE}.created_hour ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: productivity_est {
    type: number
    sql: ${TABLE}.productivity_est ;;
  }

  dimension: capacity {
    type: number
    sql: ${TABLE}.capacity ;;
  }

  dimension: expected_additional {
    type: number
    sql: ${TABLE}.expected_additional ;;
  }

  dimension: total_hours {
    type: string
    sql: ${TABLE}.total_hours ;;
  }


  dimension: expected_overflow {
    type: number
    sql: ${expected_additional} - ${capacity} ;;
  }


  dimension: created_hour_timezone {
    type: number
    sql: case when ${markets.sa_time_zone} = 'Eastern Time (US & Canada)' then ${created_hour}+2
     when ${markets.sa_time_zone} = 'Pacific Time (US & Canada)' then ${created_hour}-1
    when ${markets.sa_time_zone} = 'Central Time (US & Canada)' then ${created_hour}+1
    when ${markets.sa_time_zone} = 'Arizona' and ${created_month}::int >=3 and ${created_month}::int<11 then ${created_hour}+1
    else ${created_hour} end
    ;;

  }

  dimension: expected_overflow_percent {
    type: number
    value_format: "0%"
    sql:case when ${complete_est} >0 then ${expected_overflow}::float/${complete_est}::float else 0 end ;;
  }

  measure: diff_to_actual {
    type: number
    sql: max(${complete_est}) - ${care_request_flat.complete_count} ;;
  }



  measure: count {
    type: count
    drill_fields: []
  }
}
