view: genesys_agg {
# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
      derived_table: {
      explore_source: genesys_conversation_summary {
        column: conversationstarttime {  field: genesys_conversation_summary.conversationstarttime_date}
        column: market_id { field: markets.id }
        column: count_answered {}
        column: inbound_phone_calls {field: genesys_conversation_summary.count_distinct}
        column: count_distinct_sla {field: genesys_conversation_summary.count_distinct_sla}
        column: wait_time_minutes {field: genesys_conversation_summary.average_wait_time_minutes}
        filters: {
          field: genesys_conversation_summary.conversationstarttime_date
          value: "365 days ago for 365 days"
        }
      }
        sql_trigger_value: SELECT count(*) FROM looker_scratch.genesys_conversation_summary  where genesys_conversation_summary.conversationstarttime > current_date - interval '2 day';;
        indexes: ["conversationstarttime", "market_id"]
    }

  dimension: wait_time_minutes {
    label: "Wait Time Minutes (Inbound Demand)"
    value_format: "0.00"
    type: number
  }

  dimension: count_distinct_sla {
    label: "Count Distinct SLA (Inbound Demand)"
    type: number
  }

  measure: sum_distinct_sla {
    type: sum_distinct
    label: "Sum Distinct SLA (Inbound Demand)"
    sql: ${count_answered} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: sla_percent {
    type: number
    value_format: "0%"
    sql: ${sum_distinct_sla}::float/(nullif(${sum_inbound_demand},0))::float;;
  }


  dimension: wait_time_minutes_x_inbound_phone_calls {
    type: number
    sql: ${wait_time_minutes}*${inbound_phone_calls} ;;
  }

  measure: sum_wait_time_minutes_x_inbound_demand {
    type: sum_distinct
    sql: ${wait_time_minutes_x_inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: avg_wait_time_minutes {
    type: number
    value_format: "0.00"
    sql: case when ${sum_inbound_phone_calls} >0 then ${sum_wait_time_minutes_x_inbound_demand}::float/${sum_inbound_phone_calls}::float else 0 end ;;
  }

  dimension: inbound_demand{
    type: number
    sql: ${count_answered} +case when ${non_phone_cr.care_request_count} is not null then ${non_phone_cr.care_request_count} else 0 end;;
  }

  measure: sum_inbound_demand{
    type: sum_distinct
    sql: ${inbound_demand} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }



  measure: assigned_rate {
    type: number
    value_format: "0%"
    sql: case when ${sum_inbound_demand} >0 then ${accepted_agg.sum_accepted}::float/${sum_inbound_demand}::float else 0 end ;;
  }


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
    dimension: market_id {
      type: number
    }
    dimension: count_answered {
      label: "Count Answered (Inbound Demand)"
      type: number
    }
  dimension: inbound_phone_calls {
    label: "Count Distinct Phone Calls (Inbound Demand)"
    type: number
  }

    measure: sum_answered {
      type: sum_distinct
      sql: ${count_answered} ;;
      sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
    }

  measure: sum_inbound_phone_calls {
    type: sum_distinct
    sql: ${inbound_phone_calls} ;;
    sql_distinct_key: concat(${conversationstarttime_date}, ${market_id}) ;;
  }

  measure: answer_rate {
    value_format: "0%"
    type: number
    sql: case when ${sum_inbound_phone_calls}>0 then ${sum_answered}::float/${sum_inbound_phone_calls}::float else 0 end;;
  }

  measure: actuals_compared_to_projections {
    value_format: "0%"
    type: number
    sql: case when ${care_team_projected_volume.sum_projected}>0 then ${sum_inbound_phone_calls}::float/${care_team_projected_volume.sum_projected}::float else 0 end;;
  }

  }
