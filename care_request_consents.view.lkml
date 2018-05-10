view: care_request_consents {
  sql_table_name: public.care_request_consents ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
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

  dimension: discharge_instructions_received {
    type: yesno
    sql: ${TABLE}.discharge_instructions_received ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: override {
    type: yesno
    sql: ${TABLE}.override ;;
  }

  dimension: relationship_to_patient {
    type: string
    sql: ${TABLE}.relationship_to_patient ;;
  }

  dimension: share_docs {
    type: yesno
    sql: ${TABLE}.share_docs ;;
  }

  dimension: signature_image {
    type: string
    sql: ${TABLE}.signature_image ;;
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

  dimension: verbal_consent {
    type: yesno
    sql: ${TABLE}.verbal_consent ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
