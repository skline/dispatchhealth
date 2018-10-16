view: min_patient_complete_visit {

  derived_table: {
    sql:

  select patients.id as patient_id, min(care_request_statuses.created_at AT TIME ZONE 'UTC' AT TIME ZONE t.pg_tz) min_complete_time
from patients
join care_requests
on care_requests.patient_id=patients.id
join public.care_request_statuses
on care_request_statuses.care_request_id=care_requests.id
and care_request_statuses.name='complete'
JOIN markets
ON care_requests.market_id = markets.id
JOIN looker_scratch.timezones AS t
ON markets.sa_time_zone = t.rails_tz
group by 1

;;
    sql_trigger_value: SELECT MAX(id) FROM patients ;;
    indexes: ["patient_id"]
    }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension_group: min_complete {
    convert_tz: no
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day
    ]
    sql: ${TABLE}.min_complete_time ;;
  }

}
