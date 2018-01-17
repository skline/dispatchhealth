view: market_dimensions {
  sql_table_name: jasperdb.market_dimensions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension_group: created {
    hidden: yes
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: humanity_id {
    type: string
    sql: ${TABLE}.humanity_id ;;
  }

  dimension: market_lat {
    hidden: yes
    type: number
    sql: ${TABLE}.market_lat ;;
  }

  dimension: market_long {
    hidden: yes
    type: number
    sql: ${TABLE}.market_long ;;
  }

  dimension: market_location {
    type: location
    sql_latitude: ${market_lat} ;;
    sql_longitude: ${market_long} ;;
  }

  dimension: market_name {
    type: string
    sql: ${TABLE}.market_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension_group: updated {
    hidden: yes
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: utc_offset {
    type: string
    sql: ${TABLE}.utc_offset ;;
  }

  measure: count {
    type: count
    drill_fields: [id, market_name]
  }
}
