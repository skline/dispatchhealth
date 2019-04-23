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
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
              WHERE question = 'Smoking Status'
              GROUP BY 1,2,3,4
    ) AS ss
      ON base.chart_id = ss.chart_id AND ss.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Marital status'
        GROUP BY 1,2,3,4
    ) AS ms
      ON base.chart_id = ms.chart_id AND ms.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Code Status'
        GROUP BY 1,2,3,4
    ) AS cs
      ON base.chart_id = cs.chart_id AND cs.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Advance directive'
        GROUP BY 1,2,3,4
    ) AS ad
      ON base.chart_id = ad.chart_id AND ad.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Fall Risk: Do you feel unsteady when standing or walking?'
        GROUP BY 1,2,3,4
    ) AS fru
      ON base.chart_id = fru.chart_id AND fru.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'ADL: Do you need help with daily activities such as bathing, preparing meals, dressing, or cleaning?'
        GROUP BY 1,2,3,4
    ) AS adl
      ON base.chart_id = adl.chart_id AND adl.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Transportation: Do you have transportation to your medical appointments?'
        GROUP BY 1,2,3,4
    ) AS trn
      ON base.chart_id = trn.chart_id AND trn.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Fall Risk: In your opinion (provider), does the home or patient potentially predispose them to an increase fall risk?'
        GROUP BY 1,2,3,4
    ) AS frp
      ON base.chart_id = frp.chart_id AND frp.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Fall Risk: Do you worry about falling?'
        GROUP BY 1,2,3,4
    ) AS frw
      ON base.chart_id = frw.chart_id AND frw.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Nutrition: Do you feel you have access to health foods?'
          GROUP BY 1,2,3,4
      ) AS ntra
        ON base.chart_id = ntra.chart_id AND ntra.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Nutrition: What is the overall nutritional status of patient?'
          GROUP BY 1,2,3,4
      ) AS ntrs
        ON base.chart_id = ntrs.chart_id AND ntrs.rownum = 1
      LEFT JOIN (
        SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
                FROM athenadwh_social_history_clone
          WHERE question = 'Social Support: Do you feel safe?'
          GROUP BY 1,2,3,4
      ) AS sss
        ON base.chart_id = sss.chart_id AND sss.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Social Support: Do you feel that anyone is taking advantage of you?'
        GROUP BY 1,2,3,4
    ) AS ssa
      ON base.chart_id = ssa.chart_id AND ssa.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
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
      SELECT chart_id, question, LOWER(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Smoking - How much?'
        GROUP BY 1,2,3,4
    ) AS smk
      ON base.chart_id = smk.chart_id AND smk.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Trip/Fall Hazards'
        GROUP BY 1,2,3,4
    ) AS thaz
      ON base.chart_id = thaz.chart_id AND thaz.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
              FROM athenadwh_social_history_clone
        WHERE question = 'Review of the general cleanliness of the home'
        GROUP BY 1,2,3,4
    ) AS gcln
      ON base.chart_id = gcln.chart_id AND gcln.rownum = 1
    LEFT JOIN (
      SELECT chart_id, question, INITCAP(answer) AS answer, created_datetime, ROW_NUMBER() OVER (PARTITION BY chart_id ORDER BY created_datetime DESC) AS rownum
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

  dimension: smoking_flag {
    type: yesno
    sql: ${smoking_how_much} !='n' and ${smoking_how_much} is not null ;;
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
    description: "Fall Risk: Do you feel unsteady when standing or walking?"
    sql: ${TABLE}.fall_risk_unsteady ;;
  }

  dimension: activities_daily_living {
    type: string
    description: "ADL: Do you need help with daily activities such as bathing, preparing meals, dressing, or cleaning?"
    sql: ${TABLE}.activities_daily_living ;;
  }

  dimension: transportation {
    type: string
    description: "Transportation: Do you have transportation to your medical appointments?"
    sql: ${TABLE}.transportation ;;
  }

  dimension: lack_of_transportation_flag {
    type: yesno
    sql: LOWER(${transportation}) SIMILAR TO '%(no:|dementia|bed bound|quadraplegic)%' ;;
  }

  dimension: fall_risk_provider {
    type: string
    description: "Fall Risk: In your opinion (provider), does the home or patient potentially predispose them to an increase fall risk?"
    sql: ${TABLE}.fall_risk_provider ;;
  }

  dimension: fall_risk_per_provider_flag {
    type: yesno
    sql: ${fall_risk_provider} IS NOT NULL AND ${fall_risk_provider} <> 'N' ;;
  }

  dimension: fall_risk_worry {
    type: string
    description: "Fall Risk: Do you worry about falling?"
    sql: ${TABLE}.fall_risk_worry ;;
  }

  dimension: fall_risk_worry_flag {
    type: yesno
    sql: ${fall_risk_worry} = 'Y' ;;
  }

  dimension: advanced_directive_flag {
    type: yesno
    sql: ${advance_directive} = 'Y' ;;
  }

  dimension: nutrition_access {
    type: string
    description: "Nutrition: Do you feel you have access to health foods?"
    sql: ${TABLE}.nutrition_access ;;
  }

  dimension: lack_of_access_healthy_foods {
    type: yesno
    description: "Does the patient indicate they have a lack of access to healthy foods"
    sql: lower(${nutrition_access}) SIMILAR TO '%(no:|no,|moc )%'  ;;
  }

  dimension: nutrition_status {
    type: string
    description: "Nutrition: What is the overall nutritional status of patient?"
    sql: ${TABLE}.nutrition_status ;;
  }

  dimension: safety_feeling {
    type: string
    description: "Social Support: Do you feel safe?"
    sql: ${TABLE}.safety_feeling ;;
  }

  dimension: taking_advantage {
    type: string
    description: "Social Support: Do you feel that anyone is taking advantage of you?"
    sql: ${TABLE}.taking_advantage ;;
  }

  dimension: afford_medications {
    type: string
    description: "Financial: Can you afford the medications that your medical team has prescribed you?"
    sql: ${TABLE}.afford_medications ;;
  }

  dimension: cant_afford_medications_flag {
    type: yesno
    sql: ${afford_medications} = 'N' OR LOWER(${afford_medications}) SIMILAR TO '%(t afford|struggl)%';;
  }

  dimension: heavy_drinking {
    type: string
    description: "How many days in the past year have you had a heavy drinking consumption (4+ female, 5+ male)?"
    sql: ${TABLE}.heavy_drinking ;;
  }

  dimension: tobacco_yrs_of_use {
    type: string
    description: "Tobacco-years of use"
    sql: ${TABLE}.tobacco_yrs_of_use ;;
  }

  dimension: smoking_how_much {
    type: string
    description: "Smoking-How much?"
    sql: ${TABLE}.smoking_how_much ;;
  }

  dimension: current_smoker_flag {
    type: yesno
    sql: ${smoking_how_much} IS NOT NULL AND ${smoking_how_much} <> 'n' ;;
  }

  dimension: fall_hazards {
    type: string
    description: "Trip/Fall Hazards"
    sql: ${TABLE}.fall_hazards ;;
  }

  dimension: general_cleanliness {
    type: string
    description: "Review of the general cleanliness of the home"
    sql: ${TABLE}.general_cleanliness ;;
  }

  dimension: nutritional_status {
    type: string
    description: "Overall nutritional status of the patient"
    sql: ${TABLE}.nutritional_status ;;
  }

  dimension: overweight_obese_flag {
    type: yesno
    sql: LOWER(${nutrition_status}) SIMILAR TO '(overweight|obese)%' ;;
  }

  measure: count_distinct_charts {
    type: count_distinct
    sql: ${chart_id} ;;
    drill_fields: [patients.ehr_id, patients.first_name, patients.last_name, patients.age]
  }

}
