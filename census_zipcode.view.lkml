view: census_zipcode {
  sql_table_name: looker_scratch.census_zipcode ;;

  dimension: census_tract {
    type: string
    sql: replace(${TABLE}.census_tract, '.', '');;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
  measure: removed_zips {
    type: yesno
    sql: ${zipcode} in(85033, 85017, 85015, 85016, 85009, 85007, 85040, 85018) ;;
  }
}
