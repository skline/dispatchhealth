# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"

view: non_phone_cr {
  derived_table: {
    explore_source: care_requests {
      column: care_request_count { field: care_request_flat.care_request_count }
      column: created_date { field: care_request_flat.created_date }
      column: this_week_created { field: care_request_flat.this_week_created }
      filters: {
        field: care_requests.request_type
        value: "-phone"
      }
      filters: {
        field: care_request_flat.created_month
        value: "6 weeks"
      }
      filters: {
        field: care_request_flat.same_day_of_week_created
        value: "Yes"
      }
      filters: {
        field: care_request_flat.care_request_count
        value: "NOT NULL"
      }
    }
    sql_trigger_value: SELECT count(*) FROM care_requests ;;
    indexes: ["created_date"]
  }
  dimension: care_request_count {
    type: number
  }
  measure: sum_care_request_count{
    type: sum_distinct
    sql_distinct_key: ${created_date} ;;
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
  dimension: this_week_created {
    label: "Care Request Flat This Week Created (Yes / No)"
    type: yesno
  }
}
