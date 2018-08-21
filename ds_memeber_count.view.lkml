view: ds_memeber_count {
  sql_table_name: looker_scratch.ds_memeber_count ;;

  dimension: member_count {
    type: number
    sql: ${TABLE}.member_count ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: left(${TABLE}.zipcode,5) ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
