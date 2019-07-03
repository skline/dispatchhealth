view: addressable_items {
  label: ""
  sql_table_name: public.addressable_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: address_id {
    type: number
    sql: ${TABLE}.address_id ;;
  }

  dimension: addressable_id {
    type: number
    sql: ${TABLE}.addressable_id ;;
  }

  dimension: addressable_type {
    type: string
    sql: ${TABLE}.addressable_type ;;
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

  measure: count {
    type: count
    drill_fields: [id]
  }
}
