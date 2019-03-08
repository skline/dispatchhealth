view: clinical_encounter_icd_codes {
  derived_table: {
    sql:
    SELECT
  d.clinical_encounter_id,
  x.icd_code_id AS icd_code_id,
  d.ordering + 1 AS sequence_number,
  MAX(d.created_datetime) AS created_datetime
  FROM athenadwh_clinicalencounter_diagnosis d
    JOIN athenadwh_clinicalencounter_dxicd10 x
      ON d.clinical_encounter_dx_id = x.clinical_encounter_dx_id AND d.deleted_datetime IS NULL
    JOIN athenadwh_icdcodeall i
      ON x.icd_code_id = i.icd_code_id
  GROUP BY 1,2,3 ;;

      sql_trigger_value: SELECT MAX(created_at) FROM athenadwh_clinicalencounter_diagnosis ;;
      indexes: ["clinical_encounter_id", "icd_code_id"]
    }

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.clinical_encounter_id::varchar, ' ', ${TABLE}.icd_code_id::varchar) ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: icd_code_id {
    type: number
    sql: ${TABLE}.icd_code_id ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: created_datetime {
    type: date_time
    sql: ${TABLE}.created_datetime ;;
  }

  measure: count_distinct_icds {
    type: count_distinct
    sql: ${compound_primary_key} ;;
    sql_distinct_key: ${clinical_encounter_id} ;;
  }


}
