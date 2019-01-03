view: thpg_providers {
  sql_table_name: looker_scratch.thpg_providers ;;

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: address_1 {
    type: string
    sql: ${TABLE}.address_1 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: clinic_name {
    type: string
    sql: ${TABLE}.clinic_name ;;
  }

  dimension: degree {
    type: string
    sql: ${TABLE}.degree ;;
  }

  dimension: fax {
    type: string
    sql: ${TABLE}.fax ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: mi {
    type: string
    sql: ${TABLE}.mi ;;
  }

  dimension: npi {
    type: number
    sql: ${TABLE}.npi ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: practice_manager {
    type: string
    sql: ${TABLE}.practice_manager ;;
  }

  dimension: provider_type {
    type: string
    sql: ${TABLE}.provider_type ;;
  }

  dimension: specialty {
    type: string
    sql: ${TABLE}.specialty ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zipcd {
    type: string
    sql: ${TABLE}.zipcd ;;
  }

  dimension: zone {
    type: string
    sql: ${TABLE}.zone ;;
  }

  measure: count {
    type: count
    drill_fields: [last_name, first_name, clinic_name]
  }
}
