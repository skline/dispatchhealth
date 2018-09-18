view: dates_hours_reference_clone {
  sql_table_name: looker_scratch.dates_hours_reference_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: datehour {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      day_of_month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.datehour ;;
  }

  dimension_group: datehour_timezone {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      day_of_month,
      quarter,
      year
    ]
    convert_tz: no
    sql: ${TABLE}.datehour AT TIME ZONE 'US/Mountain' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension: day_of_week {
    type: number
    sql: ${TABLE}.day_of_week ;;
  }

  dimension: hour_of_day {
    type: number
    sql: ${TABLE}.hour_of_day ;;
  }

  dimension_group: local_date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.local_date ;;
  }

  dimension: month_of_year {
    type: number
    sql: ${TABLE}.month_of_year ;;
  }

  dimension_group: previous_month {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.previous_month_date ;;
  }

  dimension: quarter {
    type: number
    sql: ${TABLE}.quarter ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: distinct_datehour_date {
    type: number
    sql:   COUNT(DISTINCT ${datehour_date});;

    }

  measure: average_cars {
    label: "Average Number of Cars"
    value_format: "0.0"
    type: number
    sql: ${shift_teams.count_distinct_car_date_shift}::float / ${distinct_datehour_date}::float ;;
  }
  dimension: hours_til_shift_end {
    type: number
    sql: ${shift_teams.end_mountain_hour_of_day}::int - ${datehour_hour_of_day}::int ;;
  }

}
