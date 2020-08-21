view: care_team_projected_volume {
  sql_table_name: looker_scratch.care_team_projected_volume ;;

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."date" ;;
  }

  dimension: projected {
    type: number
    sql: ${TABLE}."projected" ;;
  }

  measure: sum_projected {
    type: sum_distinct
    sql_distinct_key: concat(${date_date}, ${queue}) ;;
    sql: ${projected} ;;
  }

  dimension: queue {
    type: string
    sql: ${TABLE}."queue" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
