view: provider_dimensions {
  sql_table_name: jasperdb.provider_dimensions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: advanced_practice_provider_name {
    type: string
    sql: ${TABLE}.advanced_practice_provider_name ;;
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: emt_name {
    type: string
    sql: ${TABLE}.emt_name ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  dimension: virtual_doctor_name {
    type: string
    sql: ${TABLE}.virtual_doctor_name ;;
  }

  measure: count {
    type: count
    drill_fields: [id, virtual_doctor_name, emt_name, advanced_practice_provider_name]
  }
}
