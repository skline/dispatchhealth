view: slc_data {
  sql_table_name: looker_scratch.slc_data ;;

  dimension: cagr {
    type: number
    sql: ${TABLE}.cagr ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: current_population {
    type: number
    sql: ${TABLE}.current_population ;;
  }

  dimension: denver_co {
    type: string
    sql: ${TABLE}.denver_co ;;
  }

  dimension: denver_comb_psa {
    type: string
    sql: ${TABLE}.denver_comb_psa ;;
  }

  dimension: five_population {
    type: number
    sql: ${TABLE}.five_population ;;
  }

  dimension: gsmc {
    type: string
    sql: ${TABLE}.gsmc ;;
  }

  dimension: lmc {
    type: string
    sql: ${TABLE}.lmc ;;
  }

  dimension: pvmc {
    type: string
    sql: ${TABLE}.pvmc ;;
  }

  dimension: sjh {
    type: string
    sql: ${TABLE}.sjh ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: trade_zone {
    type: string
    sql: ${TABLE}.trade_zone ;;
  }

  dimension: zip_code {
    type: zipcode
    sql: ${TABLE}.zip_code ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
