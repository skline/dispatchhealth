view: phx_crime_census {
  sql_table_name: looker_scratch.phx_crime_census ;;

  dimension: census_tract {
    type: string
    sql: replace(${TABLE}.census_tract, '.', '') ;;
  }

  measure: total_crime {
    type: sum_distinct
    sql_distinct_key: ${census_tract} ;;
    sql: ${TABLE}.total_crime ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
