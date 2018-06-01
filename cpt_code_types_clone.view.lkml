view: cpt_code_types_clone {
  sql_table_name: looker_scratch.cpt_code_types_clone ;;

  dimension: cpt_code {
    type: string
    sql: ${TABLE}.cpt_code ;;
  }

  dimension: cpt_code_type {
    type: string
    sql: ${TABLE}.cpt_code_type ;;
  }

  dimension: cpt_description {
    type: string
    sql: ${TABLE}.cpt_description ;;
  }

  dimension: e_m_level {
    type: string
    sql: ${TABLE}.e_m_level ;;
  }

  dimension: fee {
    type: number
    sql: ${TABLE}.fee ;;
  }

  dimension: new_existing_patient {
    type: string
    sql: ${TABLE}.new_existing_patient ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
