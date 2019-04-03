view: vitals_flat {
    derived_table: {
      sql: WITH vvs AS (
SELECT
  care_request_id,
  json_array_elements(json_array_elements(data::json))::json->>'clinicalelementid' AS measurement,
  json_array_elements(json_array_elements(data::json))::json->>'value' AS value,
  updated_at
FROM public.vitals)
SELECT DISTINCT
  vitals.care_request_id,
  t.value::float AS temperature,
  tt.value::varchar AS temperature_type,
  hr.value::int AS heartrate,
  hr1.value::int AS heartrate_initial,
  rr.value::int AS respiration_rate,
  sys.value::int AS bloodpressure_systolic,
  sys1.value::int AS bloodpressure_systolic_initial,
  dia.value::int AS bloodpressure_diastolic,
  dia1.value::int AS bloodpressure_diastolic_initial,
  site.value::varchar AS bloodpressure_site,
  typ.value::varchar AS bloodpressure_type,
  typ1.value::varchar AS bloodpressure_type_initial,
  o2.value::int AS o2saturation,
  o21.value::int AS o2saturation_initial,
  o2a.value::varchar AS o2saturation_airtype,
  wt.value::int/453.592 AS weight_lbs,
  MAX(vitals.created_at) AS created_at,
  MAX(vitals.updated_at) AS updated_at,
  vitals.user_id
  FROM public.vitals
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.TEMPERATURE'
          GROUP BY 1,2,3,4
    ) AS t
    ON vitals.care_request_id = t.care_request_id AND t.rownum = 1
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.TEMPERATURE.TYPE'
          GROUP BY 1,2,3,4
    ) AS tt
    ON vitals.care_request_id = tt.care_request_id AND tt.rownum = 1
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
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
          WHERE measurement = 'VITALS.RESPIRATIONRATE'
          GROUP BY 1,2,3,4
    ) AS rr
    ON vitals.care_request_id = rr.care_request_id AND rr.rownum = 1
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
          WHERE measurement = 'VITALS.BLOODPRESSURE.DIASTOLIC'
          GROUP BY 1,2,3,4
    ) AS dia
    ON vitals.care_request_id = dia.care_request_id AND dia.rownum = 1
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.BLOODPRESSURE.DIASTOLIC'
          GROUP BY 1,2,3,4
    ) AS dia1
    ON vitals.care_request_id = dia1.care_request_id AND dia1.rownum = 1
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.BLOODPRESSURE.SITE'
          GROUP BY 1,2,3,4
    ) AS site
    ON vitals.care_request_id = site.care_request_id AND site.rownum = 1
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.BLOODPRESSURE.TYPE'
          GROUP BY 1,2,3,4
    ) AS typ
    ON vitals.care_request_id = typ.care_request_id AND typ.rownum = 1
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.BLOODPRESSURE.TYPE'
          GROUP BY 1,2,3,4
    ) AS typ1
    ON vitals.care_request_id = typ1.care_request_id AND typ1.rownum = 1
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
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.O2SATURATION.AIRTYPE'
          GROUP BY 1,2,3,4
    ) AS o2a
    ON vitals.care_request_id = o2a.care_request_id AND o2a.rownum = 1
  LEFT JOIN (
          SELECT care_request_id, measurement, value,updated_at,
          ROW_NUMBER() OVER (PARTITION BY care_request_id, measurement ORDER BY updated_at DESC) AS rownum
          FROM vvs
          WHERE measurement = 'VITALS.WEIGHT'
          GROUP BY 1,2,3,4
    ) AS wt
    ON vitals.care_request_id = wt.care_request_id AND wt.rownum = 1
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,20 ;;

    sql_trigger_value: SELECT MAX(care_request_id) FROM vitals ;;
    indexes: ["care_request_id"]
  }

    dimension: care_request_id {
      type: number
      sql: ${TABLE}.care_request_id ;;
    }

  dimension: temperature {
    type: number
    sql: ${TABLE}.temperature ;;
  }

  dimension: temperature_type {
    type: string
    sql: ${TABLE}.temperature_type ;;
  }

  dimension: heartrate {
    type: number
    sql: ${TABLE}.heartrate ;;
  }

  dimension: heartrate_initial {
    type: number
    sql: ${TABLE}.heartrate_initial ;;
  }

  dimension: elevated_hr {
    type: yesno
    sql: (${patients.age} < 1 AND
         (${heartrate} < 90 OR ${heartrate_initial} < 90 OR ${heartrate} > 160 OR ${heartrate_initial} > 160))
    OR (${patients.age} >=1 AND ${patients.age} < 3 AND
       (${heartrate} < 80 OR ${heartrate_initial} < 80 OR ${heartrate} > 150 OR ${heartrate_initial} > 150))
    OR (${patients.age} >=3 AND ${patients.age} < 6 AND
       (${heartrate} < 70 OR ${heartrate_initial} < 70 OR ${heartrate} > 120 OR ${heartrate_initial} > 120))
    OR (${patients.age} >=6 AND ${patients.age} < 12 AND
       (${heartrate} < 60 OR ${heartrate_initial} < 60 OR ${heartrate} > 110 OR ${heartrate_initial} > 110))
    OR (${patients.age} >=12 AND
       (${heartrate} < 60 OR ${heartrate_initial} < 60 OR ${heartrate} > 100 OR ${heartrate_initial} > 100)) ;;
  }

  dimension: respiration_rate {
    type: number
    sql: ${TABLE}.respiration_rate ;;
  }

  dimension: abnormal_respiration_rate {
    type: yesno
    sql: (${patients.age} < 1 AND (${respiration_rate} < 22 OR ${respiration_rate} > 40))
    OR (${patients.age} >=1 AND ${patients.age} < 3 AND (${respiration_rate} < 22 OR ${respiration_rate} > 30))
    OR (${patients.age} >=3 AND ${patients.age} < 6 AND ${respiration_rate} > 24)
    OR (${patients.age} >=6 AND ${patients.age} < 12 AND ${respiration_rate} > 22)
    OR (${patients.age} >=12 AND ${respiration_rate} > 20) ;;
  }

  dimension: bloodpressure_systolic {
    type: number
    sql: ${TABLE}.bloodpressure_systolic ;;
  }

  dimension: bloodpressure_systolic_initial {
    type: number
    sql: ${TABLE}.bloodpressure_systolic_initial ;;
  }

  dimension: low_systolic_bp {
    type: yesno
    description: "Systolic BP is < 90 AND patient age is 12+"
    sql: (${bloodpressure_systolic} < 90 OR ${bloodpressure_systolic_initial} < 90) AND ${patients.age} >= 12 ;;
  }

  dimension: hypotension {
    type: yesno
    sql: ${bloodpressure_systolic} < 90 AND ${bloodpressure_diastolic} < 60 ;;
  }

  dimension: bloodpressure_diastolic {
    type: number
    sql: ${TABLE}.bloodpressure_diastolic ;;
  }

  dimension: bloodpressure_diastolic_initial {
    type: number
    sql: ${TABLE}.bloodpressure_diastolic_initial ;;
  }

  dimension: bloodpressure_site {
    type: string
    sql: ${TABLE}.bloodpressure_site ;;
  }

  dimension: bloodpressure_type {
    type: string
    sql: ${TABLE}.bloodpressure_type ;;
  }

  dimension: bloodpressure_type_initial {
    type: string
    sql: ${TABLE}.bloodpressure_type_initial ;;
  }

  dimension: bloodpressure {
    type: string
    sql: CASE
          WHEN ${bloodpressure_systolic} IS NOT NULL THEN CONCAT(${bloodpressure_systolic}::varchar, '/', ${bloodpressure_diastolic}::varchar)
          ELSE NULL
        END ;;
  }

  dimension: o2saturation {
    type: number
    sql: ${TABLE}.o2saturation ;;
  }

  dimension: o2saturation_initial {
    type: number
    sql: ${TABLE}.o2saturation_initial ;;
  }

  dimension: low_o2_saturation {
    type: yesno
    sql: ${patients.age} >=12 AND (${o2saturation} < 90 OR ${o2saturation_initial} < 90) ;;
  }

  dimension: o2saturation_airtype {
    type: string
    sql: ${TABLE}.o2saturation_airtype ;;
  }

  dimension: weight_lbs {
    type: number
    sql: ${TABLE}.weight_lbs ;;
    value_format: "0.0"
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: abnormal_vitals {
    type: yesno
    sql: ${low_o2_saturation} OR ${low_systolic_bp} OR ${elevated_hr} ;;
  }

  dimension_group: created {
    type: time
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
    sql: ${TABLE}.created_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

  dimension_group: updated {
    type: time
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
    sql: ${TABLE}.updated_at AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz} ;;
  }

}
