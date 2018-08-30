view: thpg_satellite_locations {
  sql_table_name: looker_scratch.thpg_satellite_locations ;;

  dimension: executive_director {
    type: string
    sql: ${TABLE}.executive_director ;;
  }

  dimension: main_clinic_name {
    type: string
    sql: ${TABLE}.main_clinic_name ;;
  }

  dimension: provider_first_name {
    type: string
    sql: ${TABLE}.provider_first_name ;;
  }

  dimension: provider_last_name {
    type: string
    sql: ${TABLE}.provider_last_name ;;
  }

  dimension: regional_director {
    type: string
    sql: ${TABLE}.regional_director ;;
  }

  dimension: satellite_address {
    type: string
    sql: ${TABLE}.satellite_address ;;
  }

  dimension: satellite_address_1 {
    type: string
    sql: ${TABLE}.satellite_address_1 ;;
  }

  dimension: satellite_executive_director {
    type: string
    sql: ${TABLE}.satellite_executive_director ;;
  }

  dimension: satellite_practice_name {
    type: string
    sql: ${TABLE}.satellite_practice_name ;;
  }

  dimension: satellite_regional_director {
    type: string
    sql: ${TABLE}.satellite_regional_director ;;
  }

  dimension: satellite_state {
    type: string
    sql: ${TABLE}.satellite_state ;;
  }

  dimension: satellite_zip {
    type: string
    sql: left(${TABLE}.satellite_zip,5) ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;
  }

  measure: count {
    type: count
    drill_fields: [main_clinic_name, provider_first_name, provider_last_name, satellite_practice_name]
  }
}
