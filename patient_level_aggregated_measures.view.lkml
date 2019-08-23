
view: patient_level_aggregated_measures {
  derived_table: {
    explore_source: care_requests {
      column: id { field: patients.id }
      column: count_distinct {}
      column: count_billable_est {}


      bind_filters: {
        to_field: care_request_flat.complete_date
        from_field: care_request_flat.complete_date
      }

      bind_filters: {
        to_field: insurance_coalese_crosswalk.insurance_reporting_category
        from_field: insurance_coalese_crosswalk.insurance_reporting_category
      }

      bind_filters: {
        to_field: insurance_coalese_crosswalk.insurance_package_name
        from_field: insurance_coalese_crosswalk.insurance_package_name
      }

      bind_filters: {
        to_field: insurance_coalese_crosswalk.custom_insurance_grouping
        from_field: insurance_coalese_crosswalk.custom_insurance_grouping
      }

      bind_filters: {
        to_field: athenadwh_payers_clone.custom_insurance_grouping
        from_field: athenadwh_payers_clone.custom_insurance_grouping
      }

      bind_filters: {
        to_field: markets.name_adj
        from_field: markets.name_adj
      }

      filters: {
        field: care_requests.billable_est
        value: "Yes"
    }
      filters: {
        field: patients.id
        value: "NOT NULL"
      }
    }

    # sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
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

  measure: count_distinct_patients_3_or_more_visits {
    description: "Count for distinct patients that had 3 or more visits"
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: 3_or_more_patient_visits
      value: "yes"
    }
  }

}
