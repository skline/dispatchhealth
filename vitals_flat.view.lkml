view: vitals_flat {
    derived_table: {
      sql: WITH vvs AS (
SELECT
    care_request_id,
    v.unpacked::json->>'clinicalelementid' AS measurement,
    v.unpacked::json->>'value' AS value
  FROM
    (
     SELECT
       care_request_id,
       json_array_elements(json_array_elements(data::json)) AS unpacked
     FROM public.vitals) AS v)
SELECT
  vitals.care_request_id,
  t.value::float AS temperature,
  tt.value::varchar AS temperature_type,
  hr.value::int AS heartrate,
  rr.value::int AS respiration_rate,
  sys.value::int AS bloodpressure_systolic,
  dia.value::int AS bloodpressure_diastolic,
  site.value::varchar AS bloodpressure_site,
  typ.value::varchar AS bloodpressure_type,
  o2.value::int AS o2saturation,
  o2a.value::varchar AS o2saturation_airtype,
  wt.value::int/453.592 AS weight_lbs,
  vitals.created_at,
  vitals.updated_at,
  vitals.user_id
  FROM public.vitals
  LEFT JOIN vvs AS t
    ON vitals.care_request_id = t.care_request_id AND t.measurement = 'VITALS.TEMPERATURE'
  LEFT JOIN vvs AS tt
    ON vitals.care_request_id = tt.care_request_id AND tt.measurement = 'VITALS.TEMPERATURE.TYPE'
  LEFT JOIN vvs AS hr
    ON vitals.care_request_id = hr.care_request_id AND hr.measurement = 'VITALS.HEARTRATE'
  LEFT JOIN vvs AS rr
    ON vitals.care_request_id = rr.care_request_id AND rr.measurement = 'VITALS.RESPIRATIONRATE'
  LEFT JOIN vvs AS sys
    ON vitals.care_request_id = sys.care_request_id AND sys.measurement = 'VITALS.BLOODPRESSURE.SYSTOLIC'
  LEFT JOIN vvs AS dia
    ON vitals.care_request_id = dia.care_request_id AND dia.measurement = 'VITALS.BLOODPRESSURE.DIASTOLIC'
  LEFT JOIN vvs AS site
    ON vitals.care_request_id = site.care_request_id AND site.measurement = 'VITALS.BLOODPRESSURE.SITE'
  LEFT JOIN vvs AS typ
    ON vitals.care_request_id = typ.care_request_id AND typ.measurement = 'VITALS.BLOODPRESSURE.TYPE'
  LEFT JOIN vvs AS o2
    ON vitals.care_request_id = o2.care_request_id AND o2.measurement = 'VITALS.O2SATURATION'
  LEFT JOIN vvs AS o2a
    ON vitals.care_request_id = o2a.care_request_id AND o2a.measurement = 'VITALS.O2SATURATION.AIRTYPE'
  LEFT JOIN vvs AS wt
    ON vitals.care_request_id = wt.care_request_id AND wt.measurement = 'VITALS.WEIGHT' ;;

    sql_trigger_value: SELECT MAX(care_request_id) FROM care_requests ;;
    indexes: ["care_request_id"]
  }

    dimension: care_request_id {
      type: number
      sql: ${TABLE}.chart_id ;;
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

  dimension: respiration_rate {
    type: number
    sql: ${TABLE}.respiration_rate ;;
  }

  dimension: bloodpressure_systolic {
    type: number
    sql: ${TABLE}.bloodpressure_systolic ;;
  }

  dimension: bloodpressure_diastolic {
    type: number
    sql: ${TABLE}.bloodpressure_diastolic ;;
  }

  dimension: bloodpressure_site {
    type: string
    sql: ${TABLE}.bloodpressure_site ;;
  }

  dimension: bloodpressure_type {
    type: string
    sql: ${TABLE}.bloodpressure_type ;;
  }

  dimension: o2saturation {
    type: number
    sql: ${TABLE}.o2saturation ;;
  }

  dimension: o2saturation_airtype {
    type: string
    sql: ${TABLE}.o2saturation_airtype ;;
  }

  dimension: weight_lbs {
    type: number
    sql: ${TABLE}.weight_lbs ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
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
