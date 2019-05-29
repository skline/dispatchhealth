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

dimension:  appointment_id {
  type: number
  sql: ${TABLE}.appointment_id ;;
}

dimension:  encounter_date {
  type: date
  sql: ${TABLE}.encounter_date ;;
}

dimension_group:  encounter_created {
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
  sql: ${TABLE}.encounter_created ;;
}

dimension:  name {
  type: string
  sql: ${TABLE}.name ;;
}

dimension:  document_id {
  type: number
    sql: ${TABLE}.document_id ;;
}

dimension:  patient_id {
  type: number
  sql: ${TABLE}.patient_id ;;
}

dimension:  chart_id {
  type: number
  sql: ${TABLE}.chart_id ;;
}

dimension:  clinical_provider_id {
  type: number
  sql: ${TABLE}.clinical_provider_id ;;
}

dimension:  document_class {
  type: string
  sql: ${TABLE}.document_class ;;
}

dimension:  clinical_order_type {
  type: string
  sql: ${TABLE}.clinical_order_type ;;
}

dimension:  clinical_order_genus {
  type: string
   sql: ${TABLE}.clinical_order_genus ;;
}

dimension:  status {
  type: string
  sql: ${TABLE}.status ;;
}

dimension:  source {
  type: string
  sql: ${TABLE}.source ;;
}

dimension_group: created_datetime {
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
  sql: ${TABLE}.created_datetime ;;
}

dimension:  lab_results {
  type: yesno
  description: "Document_class is Lab Result"
  sql: ${document_class} like 'LABRESULT' ;;
}

dimension:  imaging_results {
  type: yesno
  description: "Document_class is Imaging Result"
  sql: ${document_class} like 'IMAGINGRESULT' ;;
}

measure:  count_distinct_lab_results{
  type:  count_distinct
  description: "Count of Distinct Lab Results"
  sql: ${document_id} ;;
  filters: {
    field: document_class
    value: "LABRESULT"
  }
}

measure:  count_distinct_imaging_results{
  type:  count_distinct
  description: "Count of Distinct Imaging Results"
  sql: ${document_id} ;;
  filters: {
    field: document_class
    value: "IMAGINGRESULT"
  }
}

}
