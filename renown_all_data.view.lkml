view: renown_all_data {
  sql_table_name: looker_scratch.renown_all_data ;;

  dimension: all_data {
    type: number
    sql: ${TABLE}."all_data" ;;
  }

  dimension: hmo {
    type: number
    sql: ${TABLE}."hmo" ;;
  }

  dimension: ifp {
    type: number
    sql: ${TABLE}."ifp" ;;
  }

  dimension: ppo {
    type: number
    sql: ${TABLE}."ppo" ;;
  }

  dimension: scp {
    type: number
    sql: ${TABLE}."scp" ;;
  }

  dimension: tpa {
    type: number
    sql: ${TABLE}."tpa" ;;
  }

  dimension: zipcodes {
    type: string
    sql: ${TABLE}."zipcodes" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
