view: diversion_categories_flat {
    derived_table: {
      sql:
      WITH diag AS (
    SELECT
        ced.clinical_encounter_id,
        ced.ordering,
        ced.updated_at,
        SUBSTRING(TRIM(icd.diagnosis_code), 0, 4) AS diagnosis_code,
        CASE WHEN SUBSTRING(TRIM(icd.diagnosis_code), 0, 4) IN ('R41','R40','R53','F03') THEN 1 ELSE 0 END AS confusion,
        CASE WHEN SUBSTRING(TRIM(icd.diagnosis_code), 0, 4) IN ('G81','G82') THEN 1 ELSE 0 END AS wheelchair_dx
        --ROW_NUMBER() OVER (PARTITION BY ced.clinical_encounter_id, ced.ordering ORDER BY ced.updated_at DESC) AS row_num
      FROM (
        SELECT DISTINCT
          MAX(clinical_encounter_dx_id) AS clinical_encounter_dx_id,
          clinical_encounter_id,
          ordering,
          MAX(deleted_datetime) AS deleted_datetime,
          MAX(updated_at) AS updated_at
          FROM looker_scratch.athenadwh_clinicalencounter_diagnosis
          WHERE ordering <= 2
          GROUP BY 2,3
        ) AS ced
      LEFT JOIN looker_scratch.athenadwh_clinicalencounter_dxicd10 cedx
        ON ced.clinical_encounter_dx_id = cedx.clinical_encounter_dx_id
      LEFT JOIN looker_scratch.athenadwh_icdcodeall icd
        ON cedx.icd_code_id = icd.icd_code_id
      WHERE icd.diagnosis_code IS NOT NULL AND ced.deleted_datetime IS NULL
      GROUP BY 1,2,3,4,5,6
      ORDER BY 1,2
), vvs AS (
      SELECT
        care_request_id,
        json_array_elements(json_array_elements(data::json))::json->>'clinicalelementid' AS measurement,
        json_array_elements(json_array_elements(data::json))::json->>'value' AS value,
        updated_at
      FROM public.vitals)
SELECT
  cr.id AS care_request_id,
  cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz AS on_scene_time,
  dxs.diagnosis_code1,
  dxs.diagnosis_code2,
  dxs.diagnosis_code3,
  1 AS diagnosis_only,
  COALESCE(surv.survey_yes_to_er,0) AS survey_yes_to_er,
  CASE WHEN ci.name LIKE '%911%' OR er_911_alternative = 1 THEN 1 ELSE 0 END AS diversion_911,
  CASE WHEN cr.place_of_service = 'Skilled Nursing Facility' THEN 1 ELSE 0 END AS pos_snf,
  CASE WHEN cr.place_of_service = 'Assisted Living Facility' THEN 1 ELSE 0 END AS pos_al,
  CASE WHEN ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
       LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%' THEN 1 ELSE 0 END AS referral,
  CASE WHEN (CAST(EXTRACT(HOUR FROM cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz) AS INT)) > 15 OR
            (MOD(EXTRACT(DOW FROM cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz)::integer - 1 + 7, 7))
             IN (5, 6) THEN 1 ELSE 0 END AS after_hours,
  CASE WHEN
    (pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)) THEN 1 ELSE 0 END AS abnormal_vitals,
    COALESCE(dxs.confusion,0) AS confusion,
    CASE WHEN dxs.wheelchair_dx > 0 OR hb.wheelchair_homebound > 0 THEN 1 ELSE 0 END AS wheelchair_hb,
    COALESCE(ekg,0) AS ekg,
    COALESCE(nebulizer,0) AS nebulizer,
    COALESCE(iv_fluids,0) AS iv_fluids,
    COALESCE(blood_tests,0) AS blood_tests,
    COALESCE(catheter_placement,0) AS catheter_placement,
    COALESCE(laceration_repair,0) AS laceration_repair,
    COALESCE(epistaxis,0) AS epistaxis,
    COALESCE(hernia_rp_reduction,0) AS hernia_rp_reduction,
    COALESCE(joint_reduction,0) AS joint_reduction,
    COALESCE(gastronomy_tube,0) AS gastronomy_tube,
    COALESCE(abscess_drain,0) AS abscess_drain,

    --POS SNF AND (abnormal vital signs  OR altered mental status)
    CASE WHEN (cr.place_of_service = 'Skilled Nursing Facility') AND (dxs.confusion > 0 OR
      ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) THEN 1 ELSE 0 END AS dc22,

  --POS SNF AND any procedures
  CASE WHEN (cr.place_of_service = 'Skilled Nursing Facility') AND (ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) THEN 1 ELSE 0 END AS dc23,

  --POS SNF AND referral
  CASE WHEN (cr.place_of_service = 'Skilled Nursing Facility') AND
    (ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
    LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%') THEN 1 ELSE 0 END AS dc24,

  --POS SNF AND (abnormal vital signs OR altered mental status) AND any procedures
  CASE WHEN (cr.place_of_service = 'Skilled Nursing Facility') AND
    (ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) AND
    (dxs.confusion > 0 OR ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) THEN 1 ELSE 0 END AS dc25,

  --POS SNF AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday
  -- Needs after hours added but created correctly with timezone added.
  CASE WHEN (cr.place_of_service = 'Skilled Nursing Facility') AND
    ((ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) OR
    (dxs.confusion > 0 OR ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) OR
    ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
       LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%') AND
    (CAST(EXTRACT(HOUR FROM cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz) AS INT)) > 15 OR
            (MOD(EXTRACT(DOW FROM cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz)::integer - 1 + 7, 7))
             IN (5, 6) THEN 1 ELSE 0 END AS dc26,

  --POS AL AND (abnormal vital signs  OR altered mental status)
    CASE WHEN (cr.place_of_service = 'Assisted Living Facility') AND (dxs.confusion > 0 OR
      ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) THEN 1 ELSE 0 END AS dc27,

  --POS AL AND any procedures
  CASE WHEN (cr.place_of_service = 'Assisted Living Facility') AND (ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) THEN 1 ELSE 0 END AS dc28,

  --POS AL AND referral
  CASE WHEN (cr.place_of_service = 'Assisted Living Facility') AND
    (ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
    LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%') THEN 1 ELSE 0 END AS dc29,

  --POS AL AND (abnormal vital signs OR altered mental status) AND any procedures
  CASE WHEN (cr.place_of_service = 'Assisted Living Facility') AND
    (ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) AND
    (dxs.confusion > 0 OR ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) THEN 1 ELSE 0 END AS dc30,

  --POS AL AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday
  CASE WHEN (cr.place_of_service = 'Assisted Living Facility') AND
    ((ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) OR
    (dxs.confusion > 0 OR ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) OR
    ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
       LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%') AND
    (CAST(EXTRACT(HOUR FROM cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz) AS INT)) > 15 OR
            (MOD(EXTRACT(DOW FROM cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz)::integer - 1 + 7, 7))
             IN (5, 6) THEN 1 ELSE 0 END AS dc31,

   --POS Home AND (abnormal vital signs  OR altered mental status)
    CASE WHEN (cr.place_of_service = 'Home') AND (dxs.confusion > 0 OR
      ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) THEN 1 ELSE 0 END AS dc32,

  --POS Home AND any procedures
  CASE WHEN (cr.place_of_service = 'Home') AND (ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) THEN 1 ELSE 0 END AS dc33,

  --POS Home AND referral
  CASE WHEN (cr.place_of_service = 'Home') AND
    (ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
    LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%') THEN 1 ELSE 0 END AS dc34,

  --POS Home AND (abnormal vital signs OR altered mental status) AND any procedures
  CASE WHEN (cr.place_of_service = 'Home') AND
    (ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) AND
    (dxs.confusion > 0 OR ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) THEN 1 ELSE 0 END AS dc35,

  --POS Home AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday
  CASE WHEN (cr.place_of_service = 'Home') AND
    ((ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) OR
    (dxs.confusion > 0 OR ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) OR
    ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
       LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%') AND
    (CAST(EXTRACT(HOUR FROM cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz) AS INT)) > 15 OR
            (MOD(EXTRACT(DOW FROM cros.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz)::integer - 1 + 7, 7))
             IN (5, 6) THEN 1 ELSE 0 END AS dc36,

    --POS Home AND (abnormal vital signs  OR altered mental status)
    CASE WHEN (cr.place_of_service = 'Home') AND (dxs.wheelchair_dx > 0 OR hb.wheelchair_homebound > 0) AND
    (dxs.confusion > 0 OR
      ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) THEN 1 ELSE 0 END AS dc37,

  --POS Home AND wheelchair/homebound AND any procedures
  CASE WHEN (cr.place_of_service = 'Home') AND (dxs.wheelchair_dx > 0 OR hb.wheelchair_homebound > 0) AND
    (ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) THEN 1 ELSE 0 END AS dc38,

  --POS Home AND wheelchair/homebound AND referral
  CASE WHEN (cr.place_of_service = 'Home') AND (dxs.wheelchair_dx > 0 OR hb.wheelchair_homebound > 0) AND
    (ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
    LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%') THEN 1 ELSE 0 END AS dc39,

  --POS Home AND wheelchair/homebound AND (abnormal vital signs OR altered mental status) AND any procedures
  CASE WHEN (cr.place_of_service = 'Home') AND (dxs.wheelchair_dx > 0 OR hb.wheelchair_homebound > 0) AND
    (ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) AND
    (dxs.confusion > 0 OR ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) THEN 1 ELSE 0 END AS dc40,

  --POS Home AND wheelchair/homebound AND
  --(abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday
  CASE WHEN (cr.place_of_service = 'Home') AND (dxs.wheelchair_dx > 0 OR hb.wheelchair_homebound > 0) AND
    ((CAST(EXTRACT(HOUR FROM crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz) AS INT)) > 15 OR
    (MOD(EXTRACT(DOW FROM crs.started_at AT TIME ZONE 'UTC' AT TIME ZONE pg_tz)::integer - 1 + 7, 7)) IN (5, 6)) AND
    ((ekg > 0 OR nebulizer > 0 OR iv_fluids > 0 OR
    blood_tests > 0 OR laceration_repair > 0 OR epistaxis > 0 OR hernia_rp_reduction > 0 OR
    joint_reduction > 0 OR gastronomy_tube > 0 OR abscess_drain > 0) OR
    (dxs.confusion > 0 OR ((pt.age < 1 AND
         (v.heartrate < 90 OR v.heartrate_initial < 90 OR v.heartrate > 160 OR v.heartrate_initial > 160))
    OR (pt.age >=1 AND pt.age < 3 AND
       (v.heartrate < 80 OR v.heartrate_initial < 80 OR v.heartrate > 150 OR v.heartrate_initial > 150))
    OR (pt.age >=3 AND pt.age < 6 AND
       (v.heartrate < 70 OR v.heartrate_initial < 70 OR v.heartrate > 120 OR v.heartrate_initial > 120))
    OR (pt.age >=6 AND pt.age < 12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 110 OR v.heartrate_initial > 110))
    OR (pt.age >=12 AND
       (v.heartrate < 60 OR v.heartrate_initial < 60 OR v.heartrate > 100 OR v.heartrate_initial > 100))
    OR ((v.bloodpressure_systolic < 90 OR v.bloodpressure_systolic_initial < 90) AND pt.age >= 12 )
    OR (pt.age >=12 AND (v.o2saturation < 90 OR v.o2saturation_initial < 90)))) OR
    ci.type_name SIMILAR TO '%(Home Health|Provider Group)%' OR
       LOWER(cr.activated_by) SIMILAR TO '%(home health|s clinician)%') THEN 1 ELSE 0 END AS dc41

  FROM public.care_requests cr
  INNER JOIN (
    SELECT
      care_request_id,
      name,
      started_at,
      ROW_NUMBER() OVER (PARTITION BY care_request_id, name ORDER BY started_at DESC) AS row_num
    FROM public.care_request_statuses
    WHERE DATE(started_at AT TIME ZONE 'UTC' AT TIME ZONE 'US/Mountain') >= '2018-01-01') crs
    ON cr.id = crs.care_request_id AND crs.name = 'complete' AND crs.row_num = 1
  LEFT JOIN (
    SELECT
      care_request_id,
      name,
      started_at,
      ROW_NUMBER() OVER (PARTITION BY care_request_id, name ORDER BY started_at DESC) AS row_num
    FROM public.care_request_statuses) cros
    ON cr.id = cros.care_request_id AND cros.name = 'on_scene' AND cros.row_num = 1
  LEFT JOIN public.markets mkt
    ON cr.market_id = mkt.id
  LEFT JOIN looker_scratch.timezones tz
    ON mkt.sa_time_zone = tz.rails_tz
  LEFT JOIN (
    SELECT DISTINCT
      pcr.id AS care_request_id,
      ppt.id AS patient_id,
      CAST(EXTRACT(YEAR from AGE(pcrs.started_at, ppt.dob)) AS INT) AS age
    FROM public.care_requests pcr
    JOIN public.care_request_statuses pcrs
      ON pcr.id = pcrs.care_request_id AND pcrs.name = 'on_scene'
    LEFT JOIN public.patients ppt
      ON pcr.patient_id = ppt.id
    GROUP BY 1,2,3) pt
    ON cr.id = pt.care_request_id
  LEFT JOIN (
    SELECT DISTINCT
      vitals.care_request_id,
      hr.value::int AS heartrate,
      hr1.value::int AS heartrate_initial,
      sys.value::int AS bloodpressure_systolic,
      sys1.value::int AS bloodpressure_systolic_initial,
      o2.value::int AS o2saturation,
      o21.value::int AS o2saturation_initial,
      vitals.user_id
    FROM public.vitals
    LEFT JOIN (
      SELECT
        care_request_id,
        measurement,
        value,
        updated_at,
        ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
      FROM vvs
      WHERE measurement = 'VITALS.HEARTRATE'
      GROUP BY 1,2,3,4
      ) AS hr
    ON vitals.care_request_id = hr.care_request_id AND hr.rownum = 1
    LEFT JOIN (
      SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.HEARTRATE'
          GROUP BY 1,2,3,4
    ) AS hr1
    ON vitals.care_request_id = hr1.care_request_id AND hr1.rownum = 1
    LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.BLOODPRESSURE.SYSTOLIC'
          GROUP BY 1,2,3,4
    ) AS sys
    ON vitals.care_request_id = sys.care_request_id AND sys.rownum = 1
    LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.BLOODPRESSURE.SYSTOLIC'
          GROUP BY 1,2,3,4
    ) AS sys1
    ON vitals.care_request_id = sys1.care_request_id AND sys1.rownum = 1
    LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.O2SATURATION'
          GROUP BY 1,2,3,4
    ) AS o2
    ON vitals.care_request_id = o2.care_request_id AND o2.rownum = 1
    LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.O2SATURATION'
          GROUP BY 1,2,3,4
    ) AS o21
    ON vitals.care_request_id = o21.care_request_id AND o21.rownum = 1
    GROUP BY 1,2,3,4,5,6,7,8) AS v
    ON cr.id = v.care_request_id
  LEFT JOIN public.channel_items ci
    ON cr.channel_item_id = ci.id
  LEFT JOIN (
    SELECT DISTINCT
      care_request_id,
      1 AS er_911_alternative
    FROM public.notes
    WHERE note_type = 'medical-necessity' AND note = 'The patient would have called 911 or gone to ED.') AS er
  ON cr.id = er.care_request_id
  LEFT JOIN (
  SELECT DISTINCT
    care_request_id,
    1 AS wheelchair_homebound
    FROM public.notes
    WHERE note SIMILAR TO '%(mobility issues|transportation|leave the home)%') hb
  ON cr.id = hb.care_request_id
  LEFT JOIN (
    SELECT DISTINCT
      cr.id AS care_request_id,
      diag1.diagnosis_code AS diagnosis_code1,
      diag2.diagnosis_code AS diagnosis_code2,
      diag3.diagnosis_code AS diagnosis_code3,
      COALESCE(diag1.confusion,0) + COALESCE(diag2.confusion,0) + COALESCE(diag3.confusion,0) AS confusion,
      COALESCE(diag1.wheelchair_dx,0) + COALESCE(diag2.wheelchair_dx,0) + COALESCE(diag3.wheelchair_dx,0) AS wheelchair_dx
    FROM public.care_requests cr
    LEFT JOIN looker_scratch.athenadwh_clinical_encounters_clone ce
      ON cr.ehr_id = CAST(ce.appointment_id AS VARCHAR)
    JOIN diag AS diag1
      ON ce.clinical_encounter_id = diag1.clinical_encounter_id AND diag1.ordering = 0
    LEFT JOIN diag AS diag2
      ON ce.clinical_encounter_id = diag2.clinical_encounter_id AND diag2.ordering = 1
    LEFT JOIN diag AS diag3
      ON ce.clinical_encounter_id = diag3.clinical_encounter_id AND diag3.ordering = 2
    GROUP BY 1,2,3,4,5,6) AS dxs
      ON cr.id = dxs.care_request_id
  LEFT JOIN (
    SELECT
    care_request_id,
    CASE WHEN (question_dim_id = 3 AND answer_selection_value = 'Emergency Room') OR
              (question_dim_id = 9 AND answer_selection_value = 'Yes') THEN 1 ELSE 0 END AS survey_yes_to_er
    FROM survey_response_facts_clone
    WHERE care_request_id IS NOT NULL AND question_dim_id IN (3,9)
    GROUP BY 1,2
    ORDER BY care_request_id DESC) AS surv
  ON cr.id = surv.care_request_id
  LEFT JOIN (
  SELECT
    c.claim_id,
    CAST(c.claim_appointment_id AS VARCHAR) AS appointment_id,
    SUM(CASE WHEN procedure_code IN ('93005', '93010', '93000') THEN 1 ELSE 0 END) AS ekg,
    SUM(CASE WHEN procedure_code IN ('94640') THEN 1 ELSE 0 END) AS nebulizer,
    SUM(CASE WHEN procedure_code IN ('96360', '96361') THEN 1 ELSE 0 END) AS iv_fluids,
    SUM(CASE WHEN procedure_code IN ('80047', '36415', '36410', '85014', '83605', '85610', '34616') THEN 1 ELSE 0 END) AS blood_tests,
    SUM(CASE WHEN procedure_code IN ('51702', '51701', '51703', '51705') THEN 1 ELSE 0 END) AS catheter_placement,
    SUM(CASE WHEN procedure_code IN ('12001', '12002', '12004', '12011', '12013', '12014', '12015', '12031', '12032', '12034', '12035',
                                     '12036', '12041', '12042', '12044', '12051', '12052', '12053', '12054') THEN 1 ELSE 0 END) AS laceration_repair,
    SUM(CASE WHEN procedure_code IN ('30901', '30903', '30905', '30906') THEN 1 ELSE 0 END) AS epistaxis,
    SUM(CASE WHEN procedure_code IN ('49999') THEN 1 ELSE 0 END) AS hernia_rp_reduction,
    SUM(CASE WHEN procedure_code IN ('24640', '26770') THEN 1 ELSE 0 END) AS joint_reduction,
    SUM(CASE WHEN procedure_code IN ('49450', '43760') THEN 1 ELSE 0 END) AS gastronomy_tube,
    SUM(CASE WHEN procedure_code IN ('10060', '10061') THEN 1 ELSE 0 END) AS abscess_drain
    FROM looker_scratch.athenadwh_claims_clone c
    LEFT JOIN looker_scratch.athenadwh_transactions_clone t
      ON t.claim_id = c.claim_id
    GROUP BY c.claim_id, c.claim_appointment_id) AS proc
  ON cr.ehr_id = proc.appointment_id
  WHERE DATE(cros.started_at) >= '2018-01-01'
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46 ;;

        sql_trigger_value: SELECT COUNT(*) FROM care_requests ;;
        indexes: ["care_request_id", "diagnosis_code1", "diagnosis_code2", "diagnosis_code3"]

      }

dimension: care_request_id {
  primary_key: yes
  type: number
  sql: ${TABLE}.care_request_id ;;
}
  dimension: diagnosis_code1 {
    type: string
    sql: ${TABLE}.diagnosis_code1 ;;
  }
  dimension: diagnosis_code2 {
    type: string
    sql: ${TABLE}.diagnosis_code2 ;;
  }
  dimension: diagnosis_code3 {
    type: string
    sql: ${TABLE}.diagnosis_code3;;
  }
  dimension: diagnosis_only {
    type: number
    sql: ${TABLE}.diagnosis_only ;;
  }
  dimension: survey_yes_to_er {
    type: number
    sql: ${TABLE}.survey_yes_to_er ;;
  }
  dimension: diversion_911 {
    type: number
    sql: ${TABLE}.diversion_911 ;;
  }
  dimension: pos_snf {
    type: number
    sql: ${TABLE}.pos_snf ;;
  }
  dimension: pos_al {
    type: number
    sql: ${TABLE}.pos_al ;;
  }
  dimension: referral {
    type: number
    sql: ${TABLE}.referral ;;
  }
  dimension: after_hours {
    type: number
    sql: ${TABLE}.after_hours ;;
  }
  dimension: abnormal_vitals {
    type: number
    sql: ${TABLE}.abnormal_vitals ;;
  }
  dimension: confusion {
    type: number
    sql: ${TABLE}.confusion ;;
  }
  dimension: wheelchair_hb {
    type: number
    sql: ${TABLE}.wheelchair_hb ;;
  }
  dimension: ekg {
    type: number
    sql: ${TABLE}.ekg ;;
  }
  dimension: nebulizer {
    type: number
    sql: ${TABLE}.nebulizer ;;
  }
  dimension: iv_fluids {
    type: number
    sql: ${TABLE}.iv_fluids ;;
  }
  dimension: blood_tests {
    type: number
    sql: ${TABLE}.blood_tests ;;
  }
  dimension: catheter_placement {
    type: number
    sql: ${TABLE}.catheter_placement ;;
  }
  dimension: laceration_repair {
    type: number
    sql: ${TABLE}.laceration_repair ;;
  }
  dimension: epistaxis {
    type: number
    sql: ${TABLE}.epistaxis ;;
  }
  dimension: hernia_rp_reduction {
    type: number
    sql: ${TABLE}.hernia_rp_reduction ;;
  }
  dimension: joint_reduction {
    type: number
    sql: ${TABLE}.joint_reduction ;;
  }
  dimension: gastronomy_tube {
    type: number
    sql: ${TABLE}.gastronomy_tube ;;
  }
  dimension: abscess_drain {
    type: number
    sql: ${TABLE}.abscess_drain ;;
  }
  dimension: dc22 {
    type: number
    sql: ${TABLE}.dc22 ;;
  }
  dimension: dc23 {
    type: number
    sql: ${TABLE}.dc23 ;;
  }
  dimension: dc24 {
    type: number
    sql: ${TABLE}.dc24 ;;
  }
  dimension: dc25 {
    type: number
    sql: ${TABLE}.dc25 ;;
  }
  dimension: dc26 {
    type: number
    sql: ${TABLE}.dc26 ;;
  }
  dimension: dc27 {
    type: number
    sql: ${TABLE}.dc27 ;;
  }
  dimension: dc28 {
    type: number
    sql: ${TABLE}.dc28 ;;
  }
  dimension: dc29 {
    type: number
    sql: ${TABLE}.dc29 ;;
  }
  dimension: dc30 {
    type: number
    sql: ${TABLE}.dc30 ;;
  }
  dimension: dc31 {
    type: number
    sql: ${TABLE}.dc31 ;;
  }
  dimension: dc32 {
    type: number
    sql: ${TABLE}.dc32 ;;
  }
  dimension: dc33 {
    type: number
    sql: ${TABLE}.dc33 ;;
  }
  dimension: dc34 {
    type: number
    sql: ${TABLE}.dc34 ;;
  }
  dimension: dc35 {
    type: number
    sql: ${TABLE}.dc35 ;;
  }
  dimension: dc36 {
    type: number
    sql: ${TABLE}.dc36 ;;
  }
  dimension: dc37 {
    type: number
    sql: ${TABLE}.dc37 ;;
  }
  dimension: dc38 {
    type: number
    sql: ${TABLE}.dc38 ;;
  }
  dimension: dc39 {
    type: number
    sql: ${TABLE}.dc39 ;;
  }
  dimension: dc40 {
    type: number
    sql: ${TABLE}.dc40 ;;
  }
  dimension: dc41 {
    type: number
    sql: ${TABLE}.dc41 ;;
  }




}
