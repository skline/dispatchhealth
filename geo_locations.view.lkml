view: geo_locations {
  sql_table_name: public.geo_locations ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: altitude {
    type: number
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

#   measure: shift_end_last_cr_diff{
#     label: "Mins Btwn Arrival at Office and Shift End"
#     type: number
#     sql:  round(((EXTRACT(EPOCH FROM ${max_updated}::timestamp - ${care_request_flat.shift_end_time}::timestamp))/60)::decimal,2);;
#   }

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
