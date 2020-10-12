view: athena_inbox_lab_imaging_results {
  derived_table: {
    sql:
    SELECT
        dcr.document_id,
        dcr.document_class,
        dcr.status AS result_status,
        new_res.assigned_to AS new_assigned_to,
        new_res.created_datetime AS new_created,
        new_res.created_by AS new_created_by,
        new_res.note AS new_note,
        review.assigned_to AS review_assigned_to,
        review.created_datetime AS review_created,
        review.created_by AS review_created_by,
        review.note AS review_note,
        ntfy_res.assigned_to AS notify_assigned_to,
        ntfy_res.created_datetime AS notify_created,
        ntfy_res.created_by AS notify_created_by,
        ntfy_res.action_group AS notify_action_group,
        ntfy_res.note AS notify_note,
        hold_res.assigned_to AS hold_assigned_to,
        hold_res.created_datetime AS hold_created,
        hold_res.created_by AS hold_created_by,
        hold_res.note AS hold_note,
        closed_res.created_datetime AS closed_created,
        closed_res.created_by AS closed_created_by,
        closed_res.note AS closed_note
    FROM looker_scratch.athenadwh_documents_clone dcr
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE status IN ('NEW','DATAENTRY','QUEUE')) AS new_res
            ON dcr.document_id = new_res.document_id AND new_res.row_num = 1
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE status IN ('REVIEW')) AS review
            ON dcr.document_id = review.document_id AND review.row_num = 1
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            action_group,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE status IN ('NOTIFY','PENDINGLABEL')) AS ntfy_res
            ON dcr.document_id = ntfy_res.document_id AND ntfy_res.row_num = 1
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE status IN ('HOLD')) AS hold_res
            ON dcr.document_id = hold_res.document_id AND hold_res.row_num = 1
    LEFT JOIN (
        SELECT
            document_id,
            assigned_to,
            created_datetime,
            created_by,
            note,
            ROW_NUMBER() OVER(PARTITION BY document_id ORDER BY created_datetime DESC) AS row_num
        FROM looker_scratch.athenadwh_documentaction
        WHERE status IN ('CLOSED')) AS closed_res
            ON dcr.document_id = closed_res.document_id AND closed_res.row_num = 1
    WHERE dcr.document_class IN ('LABRESULT','IMAGINGRESULT') AND dcr.document_class <> 'DELETED' ;;

      sql_trigger_value: SELECT COUNT(*) FROM athenadwh_documents_clone ;;
      indexes: ["document_id"]
    }

  dimension: document_id {
    type: number
    description: "The Athena document ID"
    sql: ${TABLE}.document_id ;;
  }
  dimension: document_class {
    type: string
    description: "'LABRESULT' or 'IMAGINGRESULT'"
    sql: ${TABLE}.document_class ;;
  }
  dimension: result_status {
    type: string
    description: "The current status of the lab or imaging result"
    sql: ${TABLE}.result_status;;
  }
  dimension: new_assigned_to {
    type: string
    description: "The person or entity assigned to the new document"
    sql: ${TABLE}.new_assigned_to ;;
  }
  dimension: new_created_by {
    type: string
    description: "The person or entity who created the new result"
    sql: ${TABLE}.new_created_by ;;
  }
  dimension: new_note {
    type: string
    description: "The note associated with the new result"
    sql: ${TABLE}.new_note ;;
  }
  dimension: review_assigned_to {
    type: string
    description: "The person or entity assigned to the result review"
    sql: ${TABLE}.review_assigned_to ;;
  }
  dimension: review_created_by {
    type: string
    description: "The person or entity who created the result review"
    sql: ${TABLE}.review_created_by ;;
  }
  dimension: review_note {
    type: string
    description: "The note associated with the review"
    sql: ${TABLE}.review_note ;;
  }
  dimension: notify_assigned_to {
    type: string
    description: "The person or entity assigned to the result notification"
    sql: ${TABLE}.notify_assigned_to ;;
  }
  dimension: notify_created_by {
    type: string
    description: "The person or entity who created the result notification"
    sql: ${TABLE}.notify_created_by ;;
  }
  dimension: notify_action_group {
    type: string
    description: "The action group associated with the notification.
    This can sometimes be the results (abnormal/normal)"
    sql: ${TABLE}.notify_action_group ;;
  }
  dimension: notify_note {
    type: string
    description: "The note associated with the result notification"
    sql: ${TABLE}.notify_note ;;
  }
  dimension: hold_assigned_to {
    type: string
    description: "The person or entity assigned to the result hold"
    sql: ${TABLE}.hold_assigned_to ;;
  }
  dimension: hold_created_by {
    type: string
    description: "The person or entity who created the result hold"
    sql: ${TABLE}.hold_created_by ;;
  }
  dimension: hold_note {
    type: string
    description: "The note associated with the result hold"
    sql: ${TABLE}.hold_note ;;
  }
  dimension: closed_created_by {
    type: string
    description: "The person or entity who created the closed result"
    sql: ${TABLE}.closed_created_by ;;
  }
  dimension: closed_note {
    type: string
    description: "The note associated with the closed result"
    sql: ${TABLE}.closed_note ;;
  }
  dimension_group: new_created {
    type: time
    description: "The timestamp when the result was created"
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
    sql: ${TABLE}.new_created ;;
  }
  dimension_group: review_created {
    type: time
    description: "The timestamp when the result was set to review"
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
    sql: ${TABLE}.review_created ;;
  }
  dimension_group: notify_created {
    type: time
    description: "The timestamp when the patient/PCP/POA was notified of the results"
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
    sql: ${TABLE}.notify_created ;;
  }
  dimension_group: hold_created {
    type: time
    description: "The timestamp when the result was put on hold"
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
    sql: ${TABLE}.hold_created ;;
  }
  dimension_group: closed_created {
    type: time
    description: "The timestamp when the result was closed"
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
    sql: ${TABLE}.closed_created ;;
  }

}
