view: athena_inbox_review_provider {
  derived_table: {
    sql:
    SELECT
    da.document_action_id,
    da.document_id,
    da.document_class,
    da.action_group,
    da.system_key,
    da.created_by,
    da.created_datetime,
    da.note,
    prv.provider_first_name,
    prv.provider_last_name,
    prv.provider_npi_number
    FROM (
        SELECT
            document_action_id,
            document_id,
            document_class,
            action_group,
            system_key,
            created_by,
            created_datetime,
            note
        FROM athena.documentaction
        WHERE status = 'REVIEW' AND document_class IN ('LABRESULT','IMAGINGRESULT')
            AND created_by NOT IN ('INTERFACE','ATHENA')) AS da
    INNER JOIN athena.provider prv
        ON (prv."provider_user_name") = (da."created_by")

    ;;

  }

  dimension: document_action_id {
    type: number
    sql: ${TABLE}.document_action_id ;;
  }

  dimension: npi {
    type: number
    sql: ${TABLE}.provider_npi_number ;;
  }

  dimension_group: created {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      hour_of_day,
      time_of_day,
      date,
      time,
      week,
      month,
      day_of_week,
      day_of_month
    ]
    sql: ${TABLE}.created_datetime;;
  }
}
