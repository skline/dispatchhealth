view: census_tract_clone {
  sql_table_name: looker_scratch.census_tract_clone ;;

  dimension: aland {
    type: number
    sql: ${TABLE}.aland ;;
  }

  dimension: aland_sqmi {
    type: number
    sql: ${TABLE}.aland_sqmi ;;
  }

  dimension: awater {
    type: number
    sql: ${TABLE}.awater ;;
  }

  dimension: awater_sqmi {
    type: number
    sql: ${TABLE}.awater_sqmi ;;
  }

  dimension: census_tract {
    type: string
    sql: replace(${TABLE}.census_tract, '.', '') ;;
  }

  dimension: lat {
    type: number
    sql: ${TABLE}.lat ;;
  }

  dimension: long {
    type: number
    sql: ${TABLE}.long ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
  dimension: location {
    type: location
    sql_latitude: ${lat};;
    sql_longitude:${long};;

  }
}
