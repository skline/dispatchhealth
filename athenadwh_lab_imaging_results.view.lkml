view: athenadwh_lab_imaging_results {
  derived_table: {
    sql:
SELECT
  ce.clinical_encounter_id,
  ce.appointment_id,
  ce.encounter_date,
  ce.created_datetime AS encounter_created,
  doc.*,
  cp.name
  FROM
(SELECT
  dc.document_id
  ,cw.patient_id
  ,cw.chart_id
  ,dc.clinical_provider_id
  ,dc.document_class
  ,dc.clinical_order_type
  ,dc.clinical_order_genus
  ,dc.status
  ,dc.source
  ,dc.created_datetime
  FROM athenadwh_documents_clone dc
  JOIN athenadwh_document_crosswalk_clone cw
    ON dc.document_id = cw.document_id
  WHERE dc.document_class LIKE '%RESULT' /*AND dc.clinical_encounter_id IS NULL*/ AND dc.deleted_datetime IS NULL) AS doc
  LEFT JOIN athenadwh_clinical_encounters_clone ce
    ON ce.chart_id = doc.chart_id AND
    DATE(ce.created_datetime) <= DATE(doc.created_datetime)
    AND DATE(ce.created_datetime) <= DATE(doc.created_datetime) - interval '2 days'
  LEFT JOIN athenadwh_clinical_providers_clone cp
    ON doc.clinical_provider_id = cp.clinical_provider_id
  WHERE ce.appointment_id IS NOT NULL
  ORDER BY ce.created_datetime DESC ;;

      sql_trigger_value: SELECT MAX(appointment_id) FROM athenadwh_lab_imaging_results ;;
      indexes: ["clinical_encounter_id", "appointment_id", "document_id", "patient_id", "chart_id"]
    }

dimension: clinical_encounter_id {
  type: number
  sql: ${TABLE}.clinical_encounter_id ;;
}
}
