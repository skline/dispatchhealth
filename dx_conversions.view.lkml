view: dx_conversions {
  sql_table_name: looker_scratch.dx_conversions ;;

  dimension: campaign_type {
    type: string
    sql: ${TABLE}."campaign_type" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: medium {
    type: string
    sql: ${TABLE}."medium" ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}."patient_id" ;;
  }

  dimension_group: visit {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."visit_date" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
