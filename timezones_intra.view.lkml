view: timezones_intra {
  sql_table_name: looker_scratch.timezones_intra ;;

  dimension: pg_tz {
    type: string
    sql: ${TABLE}.pg_tz ;;
  }

  dimension: rails_tz {
    type: string
    sql: ${TABLE}.rails_tz ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
