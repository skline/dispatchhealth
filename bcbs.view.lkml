view: bcbs {
  sql_table_name: looker_scratch.bcbs ;;

  dimension: bav_total {
    type: number
    sql: ${TABLE}.bav_total ;;
  }

  dimension: commercial_hmo_pos {
    type: number
    sql: ${TABLE}.commercial_hmo_pos ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: ppo_aso {
    type: number
    sql: ${TABLE}.ppo_aso ;;
  }

  dimension: ppo_insured {
    type: number
    sql: ${TABLE}.ppo_insured ;;
  }

  dimension: ppo_total {
    type: number
    sql: ${TABLE}.ppo_total ;;
  }

  dimension: total {
    type: number
    sql: ${TABLE}.total ;;
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
