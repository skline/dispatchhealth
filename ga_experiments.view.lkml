view: ga_experiments {
  sql_table_name: looker_scratch.ga_experiments ;;

  dimension: exp_id {
    type: string
    sql: lower(${TABLE}.exp_id) ;;
  }

  dimension: exp_name {
    type: string
    sql: ${TABLE}.exp_name ;;
  }

  measure: count {
    type: count
    drill_fields: [exp_name]
  }
}
