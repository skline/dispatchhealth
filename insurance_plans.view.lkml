view: insurance_plans {
  sql_table_name: public.insurance_plans ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: active {
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension_group: created {
    type: time
    hidden: no
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

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}.note ;;
  }

  dimension: package_id {
    type: string
    description: "Athena Package ID"
    sql: ${TABLE}.package_id ;;
  }

  dimension: insurance_classification_id {
    type: string
    hidden: no
    sql: ${TABLE}.insurance_classification_id ;;
  }

  dimension: plan_type {
    type: number
    sql: ${TABLE}.plan_type ;;
  }

  dimension: primary {
    type: yesno
    sql: ${TABLE}.primary ;;
  }

  dimension: secondary {
    type: yesno
    sql: ${TABLE}.secondary ;;
  }

  dimension: state_id {
    type: number
    sql: ${TABLE}.state_id ;;
  }

  dimension: tertiary {
    type: yesno
    sql: ${TABLE}.tertiary ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
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
    drill_fields: [id, name]
  }
}
