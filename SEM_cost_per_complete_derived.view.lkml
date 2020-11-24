
  view: sem_cost_per_complete_derived {
# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"


    derived_table: {
      explore_source: ga_adwords_cost_clone {
        column: short_name_adj { field: markets.short_name_adj }
        column: count_distinct { field: genesys_conversation_summary.count_distinct }
        column: count_answered { field: genesys_conversation_summary.count_answered }
        column: accepted_count { field: care_request_flat.accepted_count }
        column: complete_count { field: care_request_flat.complete_count }
        column: diversion_savings_911 { field: diversions_by_care_request.diversion_savings_911 }
        column: diversion_savings_er { field: diversions_by_care_request.diversion_savings_er }
        column: diversion_savings_hospitalization { field: diversions_by_care_request.diversion_savings_hospitalization }
        column: diversion_savings_obs { field: diversions_by_care_request.diversion_savings_obs }
        column: sum_total_adcost {}
        column: sem_covid { field: number_to_market.sem_covid }
        column: date {field: ga_adwords_cost_clone.date_date}
        filters: {
          field: adwords_campaigns_clone.brand
          value: "No"
        }
        filters: {
          field: adwords_campaigns_clone.sem
          value: "Yes"
        }
        filters: {
          field: ga_adwords_cost_clone.date_date
          value: "2020/10/01 to 2020/11/30"
        }

      }
    }
    dimension: short_name_adj {
      description: "Market short name where WMFR is included in Denver"
    }
    dimension: count_distinct {
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
    dimension: complete_count {
      type: number
    }
    dimension: diversion_savings_911 {
      value_format: "$#,##0"
      type: number
    }
    dimension: diversion_savings_er {
      value_format: "$#,##0"
      type: number
    }
    dimension: diversion_savings_hospitalization {
      value_format: "$#,##0"
      type: number
    }
    dimension: diversion_savings_obs {
      value_format: "$#,##0"
      type: number
    }
    dimension: sum_total_adcost {
      value_format: "$#;($#)"
      type: number
    }
    dimension: sem_covid {
      label: "Number to Market Sem Covid (Yes / No)"
      type: yesno
    }

    dimension_group: date {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.date ;;
    }
  }
