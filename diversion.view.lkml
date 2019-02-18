view: diversion {
  sql_table_name: looker_scratch.diversion ;;

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

  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}.diagnosis_code ;;
  }

  dimension: diversion {
    type: yesno
    sql: ${TABLE}.diversion ;;
  }

  dimension: diversion_category_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.diversion_category_id ;;
  }

  dimension: diversion_type_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.diversion_type_id ;;
  }

  dimension: icd_code_id {
    type: number
    sql: ${TABLE}.icd_code_id ;;
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

  measure: diversion_flag {
    type: yesno
    sql: bool_or(${diversion}) ;;
  }

  measure: count {
    type: count
    drill_fields: [id, diversion_type.id, diversion_category.id]
  }
}
