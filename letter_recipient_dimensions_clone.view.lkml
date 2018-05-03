view: letter_recipient_dimensions_clone {
  sql_table_name: looker_scratch.letter_recipient_dimensions_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
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

  dimension: recipient_name {
    type: string
    sql: ${TABLE}.recipient_name ;;
  }

  dimension: recipient_organization {
    type: string
    sql: ${TABLE}.recipient_organization ;;
  }

  dimension: recipient_type {
    type: string
    sql: ${TABLE}.recipient_type ;;
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
    drill_fields: [id, recipient_name]
  }
}
