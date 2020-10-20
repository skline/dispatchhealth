view: most_recent_intraday {
  derived_table: {
    sql:
    select *
from
(select *, ROW_NUMBER() OVER(PARTITION BY market
                                ORDER BY created_hour desc) as row_number
from looker_scratch.intraday_monitoring
where intraday_monitoring.created_date=current_date
ORDER BY created_hour desc)lq
where row_number=1
    ;;

    }

    dimension: market {
      type: string
      sql: ${TABLE}.market ;;
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

  dimension: productivity_est {
    type: number
    sql: ${TABLE}.productivity_est ;;
  }
  dimension: complete_est {
    type: number
    sql: ${TABLE}.complete_est ;;
  }
  dimension: expected_additional {
    type: number
    sql: ${TABLE}.expected_additional ;;
  }
  dimension: capacity {
    type: number
    sql: ${TABLE}.capacity ;;
  }
  dimension: total_hours {
    type: number
    sql: ${TABLE}.total_hours ;;
  }


  dimension: expected_overflow {
    type: number
    sql: ${expected_additional} - ${capacity} ;;
  }

  dimension: expected_overflow_percent {
    type: number
    value_format: "0%"
    sql:case when ${complete_est} >0 then ${expected_overflow}::float/${complete_est}::float else 0 end ;;
  }



  }
