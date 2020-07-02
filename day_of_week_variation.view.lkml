view: day_of_week_variation {
    derived_table: {
      sql_trigger_value:  SELECT FLOOR(EXTRACT(epoch from NOW()) / (3.5*60*60));;
      explore_source: care_requests {
        column: name_adj { field: markets.name_adj }
        column: scheduled_care_created_coalese_day_of_week { field: care_request_flat.scheduled_care_created_coalese_day_of_week }
        column: count_distinct {}
        filters: {
          field: care_request_flat.scheduled_care_created_coalese_day_of_week
          value: "-Saturday,-Sunday"
        }
        filters: {
          field: care_request_flat.scheduled_care_created_coalese_date
          value: "42 days ago for 42 days"
        }
      }
    }
    dimension: name_adj {
      description: "Market name where WMFR is included as part of Denver"
    }
    dimension: scheduled_care_created_coalese_day_of_week {
      description: "The local date/time that the care request was created."
      type: string
    }
    dimension: count_distinct {
      type: number
    }
  }
