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

  dimension: er_diversion_type {
    type: yesno
    sql: ${diversion_type.id} = 1 ;;
  }

  measure: diversion_flag {
    type: yesno
    sql: bool_or(${diversion}) ;;
  }

  measure: er_diversion_count {
    type: sum
    sql: CASE WHEN ${diversion} THEN 1 ELSE 0 END ;;
    filters: {
      field: er_diversion_type
      value: "yes"
    }
  }

  measure: er_diversion_savings {
    type: number
    sql: 2000 * SUM(CASE WHEN ${er_diversion_count} > 0 THEN 1 ELSE 0 END)  ;;
  }

  measure: count {
    type: count
    drill_fields: [id, diversion_type.id, diversion_category.id]
  }
}
