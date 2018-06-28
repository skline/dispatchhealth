view: phx_crime_zips {
  sql_table_name: looker_scratch.phx_crime_zips ;;

  measure: total_crime {
    type: sum_distinct
    sql_distinct_key: ${zipcode} ;;
    sql: ${TABLE}.total_crime ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: removed_zips {
    type: yesno
    sql: ${zipcode} in(85033, 85017, 85015, 85016, 85009, 85007, 85040, 85018) ;;
  }
}
