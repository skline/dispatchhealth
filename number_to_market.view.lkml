view: number_to_market {
  sql_table_name: looker_scratch.number_to_market ;;

  dimension: market_id {
    type: number
    sql: ${TABLE}."market_id" ;;
  }

  dimension: market_short {
    type: string
    sql: ${TABLE}."market_short" ;;
  }

  dimension: mvp {
    type: yesno
    sql: ${TABLE}."mvp"=1 ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: number {
    type: string
    sql: ${TABLE}."number" ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
