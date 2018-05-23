view: phx_heatmap {
  sql_table_name: looker_scratch.phx_heatmap ;;

  dimension: mbs {
    type: number
    sql: ${TABLE}.mbs ;;
  }

  dimension: service_area {
    type: string
    sql: ${TABLE}.service_area ;;
  }

  dimension: tab {
    type: string
    sql: ${TABLE}.tab ;;
  }

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  dimension: zone {
    type: string
    sql: ${TABLE}.zone ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
