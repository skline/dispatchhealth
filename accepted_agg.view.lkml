view: accepted_agg {
  derived_table: {
    explore_source: care_requests {
      column: first_accepted_date { field: care_request_flat.first_accepted_date }
      column: accepted_count { field: care_request_flat.accepted_count }
      column: complete_count { field: care_request_flat.complete_count }
      column: market_id { field: markets.id }
      filters: {
        field: care_request_flat.first_accepted_date
        value: "365 days ago for 365 days"
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
    sql_trigger_value:  SELECT FLOOR(EXTRACT(epoch from NOW()) / (2*60*60));;
    indexes: ["first_accepted_date", "market_id"]
  }
  dimension: first_accepted_date {
    description: "The first local date and time when the shift team was assigned a care request"
    type: date
  }
  dimension: accepted_count {
    type: number
  }
  dimension: complete_count {
    type: number
  }
  dimension: market_id {
    type: number
  }
  measure: sum_accepted {
    type: sum_distinct
    sql: ${accepted_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }

  measure: sum_complete {
    type: sum_distinct
    sql: ${complete_count} ;;
    sql_distinct_key: concat(${first_accepted_date}, ${market_id}) ;;
  }


}
