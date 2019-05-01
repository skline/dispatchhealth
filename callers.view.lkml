view: callers {
  sql_table_name: public.callers ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: contact_id {
    type: string
    sql: ${TABLE}.contact_id ;;
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

  dimension: dh_phone {
    type: string
    sql: ${TABLE}.dh_phone ;;
  }

  dimension: first_name {
    type: string
    sql: trim(initcap(${TABLE}.first_name)) ;;
  }

  dimension: last_name {
    type: string
    sql:trim(initcap(${TABLE}.last_name)) ;;
  }

  dimension: organization_name {
    type: string
    sql: trim(initcap(${TABLE}.organization_name)) ;;
  }

  dimension: origin_phone {
    type: string
    sql: ${TABLE}.origin_phone ;;
  }

  dimension: relationship_to_patient {
    type: string
    sql: ${TABLE}.relationship_to_patient ;;
  }

  dimension: skill_name {
    type: string
    sql: ${TABLE}.skill_name ;;
  }

  dimension: title {
    type: string
    sql: trim(initcap(${TABLE}.title)) ;;
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
    drill_fields: [id, first_name, last_name, organization_name, skill_name]
  }
}
