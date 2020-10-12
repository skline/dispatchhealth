view: dx_aggregate_peformance {
  sql_table_name: looker_scratch.dx_aggregate_peformance ;;

  dimension: adj_conversions {
    type: number
    sql: ${TABLE}."adj_conversions" ;;
  }

  dimension: adj_expected_allowable {
    type: number
    sql: ${TABLE}."adj_expected_allowable" ;;
  }

  dimension: adj_expected_allowable_romi {
    type: number
    sql: ${TABLE}."adj_expected_allowable_romi" ;;
  }

  dimension: adj_savings {
    type: number
    sql: ${TABLE}."adj_savings" ;;
  }

  dimension: adj_savings_romi {
    type: number
    sql: ${TABLE}."adj_savings_romi" ;;
  }

  dimension: campaign_type {
    type: string
    sql: ${TABLE}."campaign_type" ;;
  }

  dimension: conversions {
    type: number
    sql: ${TABLE}."conversions" ;;
  }

  dimension: expected_allowable {
    type: number
    sql: ${TABLE}."expected_allowable" ;;
  }

  dimension: expected_allowable_romi {
    type: number
    sql: ${TABLE}."expected_allowable_romi" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: matchback_dates {
    type: string
    sql: ${TABLE}."matchback_dates" ;;
  }

  dimension: matchback_order {
    type: number
    sql: ${TABLE}."matchback_order" ;;
  }

  dimension: medium {
    type: string
    sql: ${TABLE}."medium" ;;
  }

  dimension: savings {
    type: number
    sql: ${TABLE}."savings" ;;
  }

  dimension: savings_romi {
    type: number
    sql: ${TABLE}."savings_romi" ;;
  }

  dimension: total_cost {
    type: number
    sql: ${TABLE}."total_cost" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
