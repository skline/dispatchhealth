view: thpg_texashealth_backcare {
  sql_table_name: looker_scratch.thpg_texashealth_backcare ;;

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

  dimension: clinic_number {
    type: string
    sql: ${TABLE}.clinic_number ;;
  }

  dimension: county {
    type: string
    sql: ${TABLE}.county ;;
  }

  dimension: degree {
    type: string
    sql: ${TABLE}.degree ;;
  }

  dimension: executive_director {
    type: string
    sql: ${TABLE}.executive_director ;;
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
    type: string
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

  dimension: provider_id {
    type: string
    sql: ${TABLE}.provider_id ;;
  }

  dimension: provider_type {
    type: string
    sql: ${TABLE}.provider_type ;;
  }

  dimension: regional_director {
    type: string
    sql: ${TABLE}.regional_director ;;
  }

  dimension: specialty {
    type: string
    sql: ${TABLE}.specialty ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: vice_president {
    type: string
    sql: ${TABLE}.vice_president ;;
  }

  dimension: zip {
    type: zipcode
    sql: left(${TABLE}.zip,5) ;;
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
