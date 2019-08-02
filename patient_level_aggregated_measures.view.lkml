# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: patient_level_aggregated_measures {
  derived_table: {
    explore_source: care_requests {
      column: id { field: patients.id }
      column: count_distinct {}
      column: count_billable_est {}
      column: count_new_patient_first_visits { field: care_request_flat.count_new_patient_first_visits }
      column: count_billable_actual {}
      column: escalated_on_scene_count { field: care_request_flat.escalated_on_scene_count }
      column: escalated_on_phone_count { field: care_request_flat.escalated_on_phone_count }
      column: count_3day_bb { field: care_request_flat.count_3day_bb }
      column: count_14day_bb { field: care_request_flat.count_14day_bb }
      column: count_30day_bb { field: care_request_flat.count_30day_bb }
      filters: {
        field: patients.id
        value: "NOT NULL"
      }
    }

    sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
    indexes: ["id"]
  }


  dimension: id {
    type: number
  }
  dimension: count_distinct {
    type: number
  }
  dimension: count_billable_est {
    description: "Count of completed care requests OR on-scene escalations"
    type: number
  }
  dimension: count_new_patient_first_visits {
    description: "Counts the number of distinct patients visited for the first time wihtin the date range of the fitered population (patient may have 1+ visits in range)"
    type: number
  }
  dimension: count_billable_actual {
    description: "Count of completed care requests OR on-scene escalations where Athena no charge entry reason is NULL"
    type: number
  }
  dimension: escalated_on_scene_count {
    type: number
  }
  dimension: escalated_on_phone_count {
    type: number
  }

  measure: sum_count_distinct_care_requests {
    description: "Sum of all care requests by patients"
    type: sum_distinct
    sql_distinct_key: ${id} ;;
    sql: ${count_distinct} ;;
  }

measure: sum_billable_est_by_patient {
  description: "Sum of billable visits by patient"
  type: sum_distinct
  sql_distinct_key: ${id} ;;
  sql: ${count_billable_est} ;;
}

dimension: 3_or_more_patient_visits {
  description: "Identifies patients that had 3 or more patient visits"
  type: yesno
  sql: ${count_billable_est} >=3 ;;
}

measure: sum_visits_by_patients_with_3_or_more_visits {
  description: "Sum of visits for patients that had 3 or more visits in the filtered time period"
  type: sum_distinct
  sql_distinct_key: ${id} ;;
  sql: ${count_billable_est} ;;
  filters: {
    field: 3_or_more_patient_visits
    value: "yes"
  }
}

}
