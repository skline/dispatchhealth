view: document_close_tmp {
  derived_table: {
    sql: WITH res_close AS (
        SELECT
            da1.document_id,
            da1.created_by,
            da1.created_datetime,
            da1.note
            FROM athena.documentaction da1
            INNER JOIN (
                SELECT
                    document_id,
                    document_action_id,
                    created_by,
                    created_datetime AS result_closed,
                    ROW_NUMBER() OVER (PARTITION BY document_id ORDER BY created_datetime DESC) AS rn
                FROM athena.documentaction
                WHERE status = 'CLOSED') AS da2
            ON da1.document_action_id = da2.document_action_id AND da2.rn = 1)
SELECT
    dr.document_id,
    dr.clinical_order_type,
    dr.created_datetime AS result_created,
    rc.created_datetime AS result_closed,
    rc.created_by,
    rc.note,
    prv.billed_name,
    prv.provider_type_name
    FROM athena.document_results dr
    INNER JOIN res_close rc
        ON dr.document_id = rc.document_id
    LEFT JOIN athena.provider prv
        ON rc.created_by = prv.scheduling_name
    WHERE dr.chart_id IS NOT NULL; ;;
    sql_trigger_value: SELECT MAX(document_id) FROM document_results ;;
    indexes: ["document_id", "created_by"]
  }

  dimension: document_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.document_id ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}.note ;;
  }

  dimension: billed_name {
    type: string
    sql: ${TABLE}.billed_name ;;
  }

  dimension: provider_type_name {
    type: string
    sql: ${TABLE}.provider_type_name ;;
  }

}
