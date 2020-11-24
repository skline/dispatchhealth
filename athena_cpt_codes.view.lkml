view: athena_cpt_codes {
  derived_table: {
    sql:
    SELECT
    ts.claim_id,
    ts.procedure_code,
    pc.procedure_code_description,
    pc.procedure_code_group
    FROM (
        SELECT
            claim_id,
            unnest(procedure_codes) AS procedure_code
            FROM athena.transactions_summary) AS ts
    LEFT JOIN athena.procedurecode pc
        ON ts.procedure_code = pc.procedure_code;;

      indexes: ["claim_id", "procedure_code"]
      sql_trigger_value: SELECT MAX(claim_id) FROM athena.claim ;;
    }

  dimension: claim_id {
    type: number
    sql: ${TABLE}.claim_id ;;
  }

  dimension: procedure_code {
    type: string
    description: "The CPT procedure code, including modifiers (e.g. 99215, 99215 QW)"
  }

  measure: procedure_codes_concatenated {
    description: "Concatenated CPT Codes"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${procedure_code}), ' | ') ;;
    group_label: "Diagnosis Codes"
  }

  dimension: procedure_code_description {
    type: string
    description: "The CPT Procedure description"
    sql: ${TABLE}.procedure_code_description ;;
  }

  measure: procedure_descriptions_concatenated {
    description: "Concatenated CPT Code Descriptions"
    type: string
    sql: array_to_string(array_agg(DISTINCT ${procedure_code_description}), ' | ') ;;
    group_label: "Diagnosis Codes"
  }

  dimension: procedure_code_group {
    type: string
    description: "The CPT Procedure group (e.g. E&M, Labs, Procedures)"
    sql: ${TABLE}.procedure_code_group ;;
  }

  dimension: e_and_m_cpt_code {
    type: yesno
    description: "A flag indicating the CPT code is an E&M code"
    sql: ${procedure_code_group} = 'E&M' ;;
  }

}
