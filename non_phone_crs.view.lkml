# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: non_phone_cr {
  derived_table: {
    explore_source: care_requests {
      column: care_request_count { field: care_request_flat.care_request_count }
      column: created_date { field: care_request_flat.created_date }
      column: created_week { field: care_request_flat.created_week }

      column: this_week_created { field: care_request_flat.this_week_created }
      column: same_day_of_week_created { field: care_request_flat.same_day_of_week_created}
      column: last_week_created { field: care_request_flat.last_week_created}
      column: market_id { field: care_request_flat.market_id}

      filters: {
        field: care_requests.request_type
        value: "-phone"
      }
      filters: {
        field: care_request_flat.created_month
        value: "365 days ago for 365 days"
      }
      filters: {
        field: care_request_flat.care_request_count
        value: "NOT NULL"
      }
      filters: {
        field: risk_assessments.protocol_name
        value: "-Covid-19 Facility Testing"
      }
      filters: {
        field: care_request_flat.pafu_or_follow_up
        value: "No"
      }
    }
    sql_trigger_value:  select count(*) from public.care_requests where care_requests.created_at > current_date - interval '2 day';;
    indexes: ["created_date", "market_id"]
  }
  dimension: care_request_count {
    type: number
  }

  dimension: market_id {
    type: number
  }
  measure: sum_care_request_count{
    type: sum_distinct
    sql_distinct_key: concat(${created_date}, ${market_id}) ;;
    sql: ${care_request_count} ;;
  }

  measure: sum_inbound_demand{
    type: number
    sql: ${genesys_conversation_summary.count_answered} +${sum_care_request_count};;
  }


  dimension: created_date {
    description: "The local date/time that the care request was created."
    type: date
  }

  dimension: created_week {
    description: "The local week that the care request was created."
    type: date
  }

  dimension: this_week_created {
    label: "Care Request Flat This Week Created"
    type: yesno
  }

  dimension: same_day_of_week_created {
    label: "Same Day of Week Created"
    type: yesno
  }

  dimension: last_week_created {
    label: "Last Week Created"
    type: yesno
  }
  measure: distinct_weeks_created {
    label: "Distinct Weeks Created"
    type: count_distinct
    sql_distinct_key: ${created_week} ;;
    sql: ${created_week}  ;;
  }

  measure: distinct_days_created {
    label: "Distinct Days Created"
    type: count_distinct
    sql_distinct_key: ${created_date} ;;
    sql: ${created_date}  ;;
    }

  measure: daily_average_created {
    type: number
    value_format: "0.0"
    sql: ${sum_inbound_demand}::float/(nullif(${distinct_days_created},0))::float  ;;
  }

  measure: weekly_average_created{
    type: number
    value_format: "0.0"
    sql: ${sum_inbound_demand}/(nullif(${distinct_weeks_created},0))::float  ;;
  }

}
