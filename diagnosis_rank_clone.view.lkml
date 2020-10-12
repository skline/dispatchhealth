view: diagnosis_rank_clone {
    view_label: "Top 3 Diagnoses"
    derived_table: {
      explore_source: care_requests {
        column: count_billable_visits { field: care_requests.count_billable_est }
        column: diagnosis_code_group { field: athenadwh_icdcodeall.diagnosis_code_group }
        column: diagnosis_description { field: athenadwh_icdcodeall.diagnosis_description }
        derived_column: rank { sql: RANK() OVER (PARTITION BY diagnosis_code_group ORDER BY count_billable_visits DESC) ;;}
        bind_all_filters: yes
        sort: { field: count_billable_visits desc: yes}
        timezone: "query_timezone"
#         limit: 3
      }
    }
    dimension: diagnosis_description { group_label: "Diagnosis Descriptions"  }
    dimension: rank { type: number group_label: "Diagnosis Descriptions" }
    dimension: diagnosis_description_ranked {
      group_label: "Diagnosis Descriptions"
      order_by_field: rank
      type: string
      sql: ${rank} || ') ' || ${diagnosis_description} ;;
    }
  }
