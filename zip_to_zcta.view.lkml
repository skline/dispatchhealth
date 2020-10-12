view: zip_to_zcta {
  sql_table_name: looker_scratch.zip_to_zcta ;;

  dimension: po_name {
    type: string
    sql: ${TABLE}.po_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zcta {
    type: zipcode
    sql: ${TABLE}.zcta ;;
  }

  dimension: zip_code {
    type: zipcode
    sql: ${TABLE}.zip_code ;;
  }

  dimension: zip_join_type {
    type: string
    sql: ${TABLE}.zip_join_type ;;
  }

  dimension: zip_type {
    type: string
    sql: ${TABLE}.zip_type ;;
  }

  measure: count {
    type: count
    drill_fields: [po_name]
  }
}
