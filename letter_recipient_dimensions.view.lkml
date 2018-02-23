view: letter_recipient_dimensions {
  sql_table_name: jasperdb.letter_recipient_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: clinical_notes_sent_flag {
    type: yesno
    sql: ${recipient_type} IS NOT NULL ;;
  }

  dimension_group: updated {
    hidden: yes
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
