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
      indexes: ["chart_id"]
    }



}
