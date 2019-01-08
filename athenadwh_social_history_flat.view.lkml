view: athenadwh_social_history_flat {
  derived_table: {
    sql:
    SELECT DISTINCT
  base.chart_id,
  CAST(rd.answer AS DATE) AS review_date,
  ss.answer AS smoking_status,
  ms.answer AS marital_status,
  cs.answer AS code_status,
  ad.answer AS advance_directive,
  fru.answer AS fall_risk_unsteady,
  adl.answer AS activities_daily_living,
  trn.answer AS transportation,
  frp.answer AS fall_risk_provider,
  frw.answer AS fall_risk_worry,
  ntra.answer AS nutrition_access,
  ntrs.answer AS nutrition_status,
  sss.answer AS safety_feeling,
  ssa.answer AS taking_advantage,
  meds.answer AS afford_medications,
  hd.answer AS heavy_drinking,
  tyrs.answer AS tobacco_yrs_of_use,
  smk.answer AS smoking_how_much,
  thaz.answer AS fall_hazards,
  gcln.answer AS general_cleanliness,
  nstat.answer AS nutritional_status

  FROM (
    SELECT DISTINCT chart_id
      FROM athenadwh_social_history_clone
  ) AS base
  LEFT JOIN (
    SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
            FROM athenadwh_social_history_clone
            WHERE question = 'Reviewed Date'
            GROUP BY 1,2,3,4
  ) AS rd
    ON base.chart_id = rd.chart_id AND rd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
              WHERE question = 'Smoking Status'
              GROUP BY 1,2,3,4
    ) AS ss
      ON base.chart_id = ss.chart_id AND ss.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Marital status'
        GROUP BY 1,2,3,4
    ) AS ms
      ON base.chart_id = ms.chart_id AND ms.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Code Status'
        GROUP BY 1,2,3,4
    ) AS cs
      ON base.chart_id = cs.chart_id AND cs.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Advance directive'
        GROUP BY 1,2,3,4
    ) AS ad
      ON base.chart_id = ad.chart_id AND ad.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Fall Risk: Do you feel unsteady when standing or walking?'
        GROUP BY 1,2,3,4
    ) AS fru
      ON base.chart_id = fru.chart_id AND fru.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'ADL: Do you need help with daily activities such as bathing, preparing meals, dressing, or cleaning?'
        GROUP BY 1,2,3,4
    ) AS adl
      ON base.chart_id = adl.chart_id AND adl.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Transportation: Do you have transportation to your medical appointments?'
        GROUP BY 1,2,3,4
    ) AS trn
      ON base.chart_id = trn.chart_id AND trn.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Fall Risk: In your opinion (provider), does the home or patient potentially predispose them to an increase fall risk?'
        GROUP BY 1,2,3,4
    ) AS frp
      ON base.chart_id = frp.chart_id AND frp.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Fall Risk: Do you worry about falling?'
        GROUP BY 1,2,3,4
    ) AS frw
      ON base.chart_id = frw.chart_id AND frw.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Nutrition: Do you feel you have access to health foods?'
          GROUP BY 1,2,3,4
      ) AS ntra
        ON base.chart_id = ntra.chart_id AND ntra.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Nutrition: What is the overall nutritional status of patient?'
          GROUP BY 1,2,3,4
      ) AS ntrs
        ON base.chart_id = ntrs.chart_id AND ntrs.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Social Support: Do you feel safe?'
          GROUP BY 1,2,3,4
      ) AS sss
        ON base.chart_id = sss.chart_id AND sss.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Social Support: Do you feel that anyone is taking advantage of you?'
        GROUP BY 1,2,3,4
    ) AS ssa
      ON base.chart_id = ssa.chart_id AND ssa.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Financial: Can you afford the medications that your medical team has prescribed you?'
        GROUP BY 1,2,3,4
    ) AS meds
      ON base.chart_id = meds.chart_id AND meds.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'How many days in the past year have you had a heavy drinking consumption (4+ female, 5+ male)?'
        GROUP BY 1,2,3,4
    ) AS hd
      ON base.chart_id = hd.chart_id AND hd.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Tobacco-years of use'
        GROUP BY 1,2,3,4
    ) AS tyrs
      ON base.chart_id = tyrs.chart_id AND tyrs.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Smoking - How much?'
        GROUP BY 1,2,3,4
    ) AS smk
      ON base.chart_id = smk.chart_id AND smk.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Trip/Fall Hazards'
        GROUP BY 1,2,3,4
    ) AS thaz
      ON base.chart_id = thaz.chart_id AND thaz.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Review of the general cleanliness of the home'
        GROUP BY 1,2,3,4
    ) AS gcln
      ON base.chart_id = gcln.chart_id AND gcln.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Overall nutritional status of patient'
        GROUP BY 1,2,3,4
    ) AS nstat
      ON base.chart_id = nstat.chart_id AND nstat.rownum = 1
    ORDER BY base.chart_id  ;;

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
    description: "The date that the social history questions were reviewed with the patients"
    convert_tz: no
    sql: ${TABLE}.review_date ;;
  }

  dimension: smoking_status {
    type: string
    sql: ${TABLE}.smoking_status ;;
  }

  dimension: marital_status {
    type: string
    sql: ${TABLE}.marital_status ;;
  }

  dimension: code_status {
    type: string
    sql: ${TABLE}.code_status ;;
  }

  dimension: advance_directive {
    type: string
    sql: ${TABLE}.advance_directive ;;
  }

  dimension: fall_risk_unsteady {
    type: string
    sql: ${TABLE}.fall_risk_unsteady ;;
  }

  dimension: activities_daily_living {
    type: string
    sql: ${TABLE}.activities_daily_living ;;
  }

  dimension: transportation {
    type: string
    sql: ${TABLE}.transportation ;;
  }

  dimension: fall_risk_provider {
    type: string
    sql: ${TABLE}.fall_risk_provider ;;
  }

  dimension: fall_risk_worry {
    type: string
    sql: ${TABLE}.fall_risk_worry ;;
  }

  dimension: nutrition_access {
    type: string
    sql: ${TABLE}.nutrition_access ;;
  }

  dimension: nutrition_status {
    type: string
    sql: ${TABLE}.nutrition_status ;;
  }

  dimension: safety_feeling {
    type: string
    sql: ${TABLE}.safety_feeling ;;
  }

  dimension: taking_advantage {
    type: string
    sql: ${TABLE}.taking_advantage ;;
  }

  dimension: afford_medications {
    type: string
    sql: ${TABLE}.afford_medications ;;
  }

  dimension: heavy_drinking {
    type: string
    sql: ${TABLE}.heavy_drinking ;;
  }

  dimension: tobacco_yrs_of_use {
    type: string
    sql: ${TABLE}.tobacco_yrs_of_use ;;
  }

  dimension: smoking_how_much {
    type: string
    sql: ${TABLE}.smoking_how_much ;;
  }

  dimension: fall_hazards {
    type: string
    sql: ${TABLE}.fall_hazards ;;
  }

  dimension: general_cleanliness {
    type: string
    sql: ${TABLE}.general_cleanliness ;;
  }

  dimension: nutritional_status {
    type: string
    sql: ${TABLE}.nutritional_status ;;
  }

}
