view: uhc_member_data {
  sql_table_name: looker_scratch.uhc_member_data ;;

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: members {
    type: number
    sql: ${TABLE}.members ;;
  }

  measure: sum_members  {
    type: sum_distinct
    sql_distinct_key: concat(${brand}, ${zipcode}, ${city}) ;;
    sql: ${members} ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
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
