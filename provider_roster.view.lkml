view: provider_roster {
  sql_table_name: looker_scratch.provider_roster ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: address1 {
    type: string
    sql: ${TABLE}."address1" ;;
  }

  dimension: address2 {
    type: string
    sql: ${TABLE}."address2" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."city" ;;
  }

  dimension_group: created {
    type: time
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

  dimension: degree {
    type: string
    sql: ${TABLE}."degree" ;;
  }

  dimension_group: deleted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."deleted_at" ;;
  }

  dimension: fax {
    type: string
    sql: ${TABLE}."fax" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: medical_group {
    type: string
    sql: ${TABLE}."medical_group" ;;
  }

  dimension: middle {
    type: string
    sql: ${TABLE}."middle" ;;
  }

  dimension: npi {
    type: number
    sql: ${TABLE}."npi" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."phone" ;;
  }

  dimension: provider_network_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."provider_network_id" ;;
  }

  dimension: specialty {
    type: string
    sql: ${TABLE}."specialty" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."state" ;;
  }

  dimension_group: updated {
    type: time
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

  dimension: zipcd {
    type: string
    sql: ${TABLE}."zipcd" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, provider_network.id, provider_network.name]
  }
}
