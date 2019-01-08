view: athenadwh_medical_history_flat {
  derived_table: {
    sql:
    SELECT DISTINCT
  base.chart_id,
  CAST(rd.answer AS DATE) AS review_date,
  notes.answer AS notes,
  hyp.answer AS hypertension,
  hch.answer AS high_cholesterol,
  diabetes.answer AS diabetes,
  copd.answer AS copd,
  asthma.answer AS asthma,
  cnc.answer AS cancer,
  kd.answer AS kidney_disease,
  stroke.answer AS stroke,
  dep.answer AS depression,
  cad.answer AS coronary_artery_disease,
  pe.answer AS pulmonary_embolism
  FROM (
    SELECT DISTINCT chart_id
      FROM athenadwh_medical_history_clone
  ) AS base
  LEFT JOIN (
    SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
            FROM athenadwh_medical_history_clone
            WHERE question = 'Reviewed Date'
            GROUP BY 1,2,3,4
  ) AS rd
    ON base.chart_id = rd.chart_id AND rd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
              WHERE question = 'Notes'
              GROUP BY 1,2,3,4
    ) AS notes
      ON base.chart_id = notes.chart_id AND notes.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Hypertension'
        GROUP BY 1,2,3,4
    ) AS hyp
      ON base.chart_id = hyp.chart_id AND hyp.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'High Cholesterol'
        GROUP BY 1,2,3,4
    ) AS hch
      ON base.chart_id = hch.chart_id AND hch.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Diabetes'
        GROUP BY 1,2,3,4
    ) AS diabetes
      ON base.chart_id = diabetes.chart_id AND diabetes.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'COPD'
        GROUP BY 1,2,3,4
    ) AS copd
      ON base.chart_id = copd.chart_id AND copd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Asthma'
        GROUP BY 1,2,3,4
    ) AS asthma
      ON base.chart_id = asthma.chart_id AND asthma.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Cancer'
        GROUP BY 1,2,3,4
    ) AS cnc
      ON base.chart_id = cnc.chart_id AND cnc.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Kidney Disease'
        GROUP BY 1,2,3,4
    ) AS kd
      ON base.chart_id = kd.chart_id AND kd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_medical_history_clone
        WHERE question = 'Stroke'
        GROUP BY 1,2,3,4
    ) AS stroke
      ON base.chart_id = stroke.chart_id AND stroke.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_medical_history_clone
          WHERE question = 'Depression'
          GROUP BY 1,2,3,4
      ) AS dep
        ON base.chart_id = dep.chart_id AND dep.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_medical_history_clone
          WHERE question = 'Coronary Artery Disease'
          GROUP BY 1,2,3,4
      ) AS cad
        ON base.chart_id = cad.chart_id AND cad.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_medical_history_clone
          WHERE question = 'Pulmonary Embolism'
          GROUP BY 1,2,3,4
      ) AS pe
        ON base.chart_id = pe.chart_id AND pe.rownum = 1
    ORDER BY base.chart_id ;;

      sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
      indexes: ["chart_id"]
    }

  dimension: chart_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.chart_id ;;
  }

  dimension: review_date {
    type: date
    sql: ${TABLE}.review_date ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}.notes ;;
  }

  dimension: hypertension {
    type: string
    sql: ${TABLE}.hypertension ;;
  }

  dimension: high_cholesterol {
    type: string
    sql: ${TABLE}.high_cholesterol ;;
  }

  dimension: diabetes {
    type: string
    sql: ${TABLE}.diabetes ;;
  }

  dimension: copd {
    type: string
    sql: ${TABLE}.copd ;;
  }

  dimension: asthma {
    type: string
    sql: ${TABLE}.asthma ;;
  }

  dimension: cancer {
    type: string
    sql: ${TABLE}.cancer ;;
  }

  dimension: kidney_disease {
    type: string
    sql: ${TABLE}.kidney_disease ;;
  }

  dimension: stroke {
    type: string
    sql: ${TABLE}.stroke ;;
  }

  dimension: depression {
    type: string
    sql: ${TABLE}.depression ;;
  }

  dimension: coronary_artery_disease {
    type: string
    sql: ${TABLE}.coronary_artery_disease ;;
  }

  dimension: pulmonary_embolism {
    type: string
    sql: ${TABLE}.pulmonary_embolism ;;
  }

}
