view: diversion_type {
  sql_table_name: looker_scratch.diversion_type ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: diversion_type_er {
    description: "ER Avoidance flag"
    type: yesno
    sql: ${id} = 1;;
  }

  dimension: diversion_type_911 {
    description: "911 Avoidance flag"
    type: yesno
    sql: ${id} = 2;;
  }

  dimension: diversion_type_hospitalization {
    description: "Hospitalization Avoidance flag"
    type: yesno
    sql: ${id} = 3;;
  }

  dimension: diversion_type_observation {
    description: "Observation Avoidance flag"
    type: yesno
    sql: ${id} = 4;;
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

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
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
    drill_fields: [id, diversion.count]
  }
}
