view: genesys_queue_conversion {
# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
    derived_table: {
      explore_source: genesys_conversation_summary {
        column: inbound_phone_calls {field: genesys_conversation_summary.count_distinct}
        column: count_answered {}
        column: accepted_count { field: care_request_flat_number.accepted_count }
        column: queuename_adj {}
        column: conversationstarttime {  field: genesys_conversation_summary.conversationstarttime_date}
        column: wait_time_minutes {field: genesys_conversation_summary.average_wait_time_minutes}
        filters: {
          field: genesys_conversation_summary.count_distinct
          value: ">0"
        }
        filters: {
          field: genesys_conversation_summary.conversationstarttime_date
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
      #sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_conversation_summary ;;
      #indexes: ["conversationstarttime", "market_id"]
    }
    dimension: inbound_phone_calls {
      label: "Genesys Conversation Summary Count Distinct (Inbound Demand)"
      type: number
    }
    dimension: count_answered {
      label: "Genesys Conversation Summary Count Answered (Inbound Demand)"
      type: number
    }
    dimension: accepted_count {
      type: number
    }
    dimension: queuename_adj {}

  dimension_group: conversationstarttime {
    type: time
    timeframes: [
      raw,
      time,
      time_of_day,
      hour_of_day,
      date,
      day_of_week,
      day_of_week_index,
      week,
      month,
      quarter,
      year, day_of_month
    ]
  }
    dimension: wait_time_minutes {
      label: "Genesys Conversation Summary Average Wait Time Minutes (Inbound Demand)"
      value_format: "0.00"
      type: number
    }
  dimension: wait_time_minutes_x_inbound_phone_calls {
    type: number
    sql: ${wait_time_minutes}*${inbound_phone_calls} ;;
  }

  measure: sum_inbound_phone_calls {
    type: sum_distinct
    sql: ${inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename_adj}) ;;
  }

  measure: sum_wait_time_minutes_x_inbound_demand {
    type: sum_distinct
    sql: ${wait_time_minutes_x_inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename_adj}) ;;
  }

  measure: sum_accepted_count {
    type: sum_distinct
    sql: ${accepted_count} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${queuename_adj}) ;;
  }

  measure: avg_wait_time_minutes {
    type: number
    value_format: "0.00"
    sql: case when ${sum_inbound_phone_calls} >0 then ${sum_wait_time_minutes_x_inbound_demand}::float/${sum_inbound_phone_calls}::float else 0 end ;;
  }

  measure: assigned_rate {
    type: number
    value_format: "0%"
    sql: case when ${sum_inbound_phone_calls} >0 then ${sum_accepted_count}::float/${sum_inbound_phone_calls}::float else 0 end ;;
  }


  }
