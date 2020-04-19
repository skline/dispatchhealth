view: athena_inbox_tracking {
    derived_table: {
      sql:
SELECT DISTINCT
    dc.document_id,
    rst_rcvd.result_document_id,
    dc.clinical_encounter_id,
    dc.clinical_provider_id,
    dc.document_class,
    dc.clinical_order_type,
    dc.clinical_order_genus,
    dc.status,
    new_doc.assigned_to AS assigned_to_new,
    new_doc.created_datetime AS created_new,
    new_doc.created_by AS created_by_new,
    appr.assigned_to AS assigned_to_approved,
    appr.created_datetime AS created_approved,
    appr.created_by AS created_by_approved,
    appr.note AS note_approved,
    qfax.assigned_to AS assigned_to_qfax,
    qfax.created_datetime AS created_qfax,
    qfax.created_by AS created_by_qfax,
    fxsent.created_datetime AS created_faxsent,
    fxsent.created_by AS created_by_faxsent,
    fxconf.created_datetime AS created_faxconf,
    fxconf.created_by AS created_by_faxconf,
    fxconf.note AS note_faxconf,
    rst_rcvd.created_datetime AS created_result,
    rst_rcvd.created_by AS created_by_result,
    rst_rcvd.note AS note_result,
    closed.created_datetime AS closed_datetime,
    closed.created_by AS closed_created_by,
    closed.note AS closed_note
    FROM looker_scratch.athenadwh_documents_clone dc
    INNER JOIN (
        --Get only non-deleted orders and prescriptions that have been prescribed (not administered)
        SELECT DISTINCT
                dcd.document_id
            FROM looker_scratch.athenadwh_documents_clone dcd
            LEFT JOIN looker_scratch.athenadwh_documentaction da
                ON dcd.document_id = da.document_id
            LEFT JOIN looker_scratch.athenadwh_patient_medication_clone pmd
                ON dcd.document_id = pmd.document_id
            WHERE dcd.status NOT IN ('DELETED') AND
                  (dcd.document_class='ORDER' OR (dcd.document_class='PRESCRIPTION' AND pmd.prescribed_yn = 'Y'))) AS deleted
        ON dc.document_id = deleted.document_id
    -- Join on new order created (new_doc)
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note
        FROM looker_scratch.athenadwh_documentaction
        WHERE system_key = 'NEW') AS new_doc
        ON dc.document_id = new_doc.document_id
    -- Join on order approved (appr)
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE system_key IN ('APPROVE_ORDER','APPROVE_PRESCRIPTION')) AS appr
        ON dc.document_id = appr.document_id AND appr.row_num = 1
    -- Join on queue fax (qfax)
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE system_key IN ('QUEUE_FAX','RX_SUBMIT_VIA_INTERFACE')) AS qfax
        ON dc.document_id = qfax.document_id AND qfax.row_num = 1
    -- Join on fax sent (fxsent)
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE system_key IN ('FAXSENT','INTERFACEPRESCRIPTIONSUBMITTED','INTERFACEPRESCRIPTIONSUBMITOK')) AS fxsent
        ON dc.document_id = fxsent.document_id AND fxsent.row_num = 1
    -- Join on fax confirmed (fxconf)
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE system_key IN ('FAXCONFIRMEDSUBMITTED','RXSUBMISSIONVERIFY','FAXCONFIRMED')) AS fxconf
        ON dc.document_id = fxconf.document_id AND fxconf.row_num = 1
    -- Join on order result received (rst_rcvd)
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            CASE
                WHEN note LIKE 'Result received as document%' THEN CAST(regexp_replace(note, '^.* ', '') AS INT)
                ELSE NULL
            END AS result_document_id,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE system_key = 'ORDER_RESULT_RECEIVED') AS rst_rcvd
        ON dc.document_id = rst_rcvd.document_id AND rst_rcvd.row_num = 1
    LEFT JOIN (
        SELECT
            document_id,
            --assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE status = 'CLOSED') AS closed
        ON dc.document_id = closed.document_id AND closed.row_num = 1
    WHERE dc.document_class IN ('ORDER','PRESCRIPTION') AND dc.clinical_order_type NOT LIKE '%REFERRAL%' ;;

        sql_trigger_value: SELECT COUNT(*) FROM athenadwh_documents_clone ;;
        indexes: ["document_id", "clinical_encounter_id", "clinical_provider_id"]
      }

  dimension: document_id {
    primary_key: yes
    type: number
    description: "The Athena document ID associated with 'ORDER' or 'PRESCRIPTION'"
    sql: ${TABLE}.document_id ;;
  }

  dimension: result_document_id {
    type: number
    description: "The Athena document ID associated with the LABRESULT or IMAGINGRESULT"
    sql: ${TABLE}.result_document_id ;;
  }

  measure: count_distinct_documents {
    type: count_distinct
    sql: ${document_id} ;;
  }

  dimension: clinical_encounter_id {
    type: number
    description: "The clinical encounter associated with the document"
    sql: ${TABLE}.clinical_encounter_id ;;
  }
  dimension: clinical_provider_id {
    type: number
    description: "The clinical provider to whom the order was sent"
    sql: ${TABLE}.clinical_provider_id ;;
  }
  dimension: document_class {
    type: string
    description: "The type of document (ORDER or PRESCRIPTION)"
    sql: ${TABLE}.document_class ;;
  }
  dimension: clinical_order_type {
    type: string
    description: "The description of the document (medication name or order description)"
    sql: ${TABLE}.clinical_order_type ;;
  }
  dimension: clinical_order_genus {
    type: string
    description: "The high-level genus of the order (e.g. XR)"
    sql: ${TABLE}.clinical_order_genus ;;
  }
  dimension: status {
    type: string
    description: "The current status of the document"
    sql: ${TABLE}.status ;;
  }
  dimension: assigned_to_new {
    type: string
    description: "The person or entity to whom the new document is assigned"
    sql: ${TABLE}.assigned_to_new ;;
  }

  dimension: created_by_new {
    type: string
    description: "The person or entity that created the new document"
    sql: ${TABLE}.created_by_new ;;
  }
  dimension: assigned_to_approved {
    type: string
    description: "The person or entity assigned to approve the document"
    sql: ${TABLE}.assigned_to_approved ;;
  }

  dimension: created_by_approved {
    type: string
    description: "The person or entity that created the approval"
    sql: ${TABLE}.created_by_approved ;;
  }
  dimension: note_approved {
    type: string
    description: "The note associated with the approval"
    sql: ${TABLE}.note_approved ;;
  }
  dimension: assigned_to_qfax {
    type: string
    description: "The person or entity assigned to the document queue submission"
    sql: ${TABLE}.assigned_to_qfax ;;
  }

  dimension: created_by_qfax {
    type: string
    description: "The person or entity who created the document queue submission"
    sql: ${TABLE}.created_by_qfax ;;
  }

  dimension: created_by_faxsent {
    type: string
    description: "The person or entity who created the FAX or SureScripts submission"
    sql: ${TABLE}.created_by_faxsent ;;
  }

  dimension: created_by_faxconf {
    type: string
    description: "The person or entity who created the FAX or SureScripts submission confirmation"
    sql: ${TABLE}.created_by_faxconf ;;
  }
  dimension: note_faxconf {
    type: string
    description: "The note associated with the FAX or SureScripts submission confirmation"
    sql: ${TABLE}.note_faxconf ;;
  }

  dimension: created_by_result {
    type: string
    description: "The person or entity who created the document result"
    sql: ${TABLE}.created_by_result ;;
  }
  dimension: note_result {
    type: string
    description: "The note associated with the document result"
    sql: ${TABLE}.note_result ;;
  }

  dimension: closed_created_by {
    type: string
    description: "The person or entity who closed the document"
    sql: ${TABLE}.closed_created_by ;;
  }
  dimension: closed_note {
    type: string
    description: "The note associated with the document closure"
    sql: ${TABLE}.closed_note ;;
  }
  dimension_group: created_new {
    type: time
    description: "The timestamp when the document was created"
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_new ;;
  }
  dimension_group: created_approved {
    type: time
    description: "The timestamp when the order was approved"
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_approved ;;
  }
  dimension_group: created_qfax {
    type: time
    description: "The timestamp when the FAX was queued to be sent"
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_qfax ;;
  }
  dimension_group: created_faxsent {
    type: time
    description: "The timestamp when the FAX or SureScripts order was sent"
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_faxsent ;;
  }
  dimension: new_to_confirmed_hours {
    description: "The number of hours between document creation and submission confirmation"
    type: number
    sql: (EXTRACT(EPOCH FROM ${created_faxconf_raw}) - EXTRACT(EPOCH FROM ${created_new_raw}))/3600;;
    value_format: "0.0"
  }

  dimension: confirmed_to_review_hours {
    description: "The number of hours between document submission confirmation and provider review"
    type: number
    sql: (EXTRACT(EPOCH FROM ${athena_inbox_lab_imaging_results.review_created_raw}) - EXTRACT(EPOCH FROM ${created_faxconf_raw}))/3600;;
    value_format: "0.0"
  }

  dimension_group: created_faxconf {
    type: time
    description: "The timstamp when the FAX or SureScripts submission was confirmed as successful"
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_faxconf ;;
  }
  dimension_group: created_result {
    type: time
    description: "The timestamp when the result was available"
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_result ;;
  }
  dimension: confirmed_to_result_hours {
    description: "The number of hours between submission verification and result"
    type: number
    sql: (EXTRACT(EPOCH FROM ${created_result_raw}) - EXTRACT(EPOCH FROM ${created_faxconf_raw}))/3600;;
    value_format: "0.0"
  }
  dimension_group: closed {
    type: time
    description: "The timestamp when the document was closed"
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.closed_datetime ;;
  }


}
