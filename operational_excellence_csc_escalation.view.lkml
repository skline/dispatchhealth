view: operational_excellence_csc_escalation {
  derived_table: {
    explore_source: care_requests {
      column: csc_name { field: csc_created.csc_name }
      column: created_month { field: care_request_flat.created_month }
      column: escalated_on_phone_count { field: care_request_flat.escalated_on_phone_count }
      column: count_distinct {}
      filters: {
        field: care_request_flat.created_date
        value: "2 months ago for 2 months"
      }
      filters: {
        field: care_request_flat.secondary_screening
        value: "No"
      }
      filters: {
        field: care_requests.count_distinct
        value: "[30, 1500]"
      }
    }
  }
  dimension: csc_name {}
  dimension: created_month {
    description: "The local date/time that the care request was created."
    type: date_month
  }
  dimension: escalated_on_phone_count {
    type: number
  }
  dimension: count_distinct {
    type: number
  }
}
