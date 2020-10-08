view: market_regions {
  sql_table_name: market_attributes.market_regions ;;

  dimension: clinical_region {
    type: string
    description: "Mountain, Plains, etc."
    sql: ${TABLE}."clinical_region" ;;
    drill_fields: [markets.name_adj]
  }

  dimension_group: created {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_at" ;;
  }

  dimension: division {
    type: string
    description: "East or West"
    sql: ${TABLE}."division" ;;
    drill_fields: [clinical_region, operations_region, markets.name_adj]
  }

  dimension: division_app {
    type: string
    sql: ${TABLE}."division_app" ;;
  }

  dimension: division_app_id {
    type: number
    hidden: yes
    sql: ${TABLE}."division_app_id" ;;
  }

  dimension: division_operations_vp {
    type: string
    sql: ${TABLE}."division_operations_vp" ;;
  }

  dimension: division_operations_vp_id {
    type: number
    hidden: yes
    sql: ${TABLE}."division_operations_vp_id" ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}."market" ;;
  }

  dimension: market_id {
    type: number
    hidden: yes
    sql: ${TABLE}."market_id" ;;
  }

  dimension: operations_region {
    type: string
    description: "Mountain, Plains, etc."
    sql: ${TABLE}."operations_region" ;;
    drill_fields: [markets.name_adj]
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."updated_at" ;;
  }

}
