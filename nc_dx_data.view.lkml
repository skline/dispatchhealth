view: nc_dx_data {
  sql_table_name: looker_scratch.nc_dx_data ;;

  dimension: age_65 {
    type: number
    sql: ${TABLE}.age_65 ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: population {
    type: number
    sql: ${TABLE}.population ;;
  }

  dimension: top_20 {
    type: number
    sql: ${TABLE}.top_20 ;;
  }

  dimension: top_20_age_35_64 {
    type: number
    sql: ${TABLE}.top_20_age_35_64 ;;
  }

  dimension: top_20_age_65 {
    type: number
    sql: ${TABLE}.top_20_age_65 ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
