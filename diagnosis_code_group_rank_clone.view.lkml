view: diagnosis_code_group_rank_clone {
  view_label: "Top 3 Diagnosis Code Groups"
  derived_table: {
    explore_source: care_requests {
      column: count_billable_visits { field: care_requests.count_billable_est }
      column: diagnosis_code_group { field: athenadwh_icdcodeall.diagnosis_code_group }
      derived_column: rank { sql: RANK() OVER (ORDER BY count_billable_visits DESC) ;;}
      bind_all_filters: yes
      sort: { field: count_billable_visits desc: yes}
      timezone: "query_timezone"
#         limit: 3
    }
  }
  dimension: diagnosis_code_group { group_label: "Diagnosis Code Group"  }
  dimension: rank { type: number group_label: "Diagnosis Code Group" }
  dimension: diagnosis_code_group_ranked {
    group_label: "Diagnosis Code Group"
    order_by_field: rank
    type: string
    sql: ${rank} || ') ' || ${diagnosis_code_group} ;;
  }
}
