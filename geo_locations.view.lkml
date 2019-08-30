view: geo_locations {
  sql_table_name: public.geo_locations ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: altitude {
    type: number
    hidden: yes
    sql: ${TABLE}.altitude ;;
  }

  dimension: base {
    type: yesno
    sql: ${TABLE}.base ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz}  ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: geo_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension_group: updated {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  measure: max_updated {
    type: time
    sql: MAX(${updated_raw}) ;;
  }


  dimension: velocity {
    type: number
    sql: ${TABLE}.velocity ;;
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
