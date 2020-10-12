view: max_daily_complete {
# If necessary, uncomment the line below to include explore_source.
# include: "dashboard.model.lkml"
      derived_table: {
      explore_source: daily_volume {
        column: name_adj {}
        column: max_complete_count {}
      }
    }
    dimension: name_adj {
      description: "Market name where WMFR is included as part of Denver"
    }
    dimension: max_complete_count {
      type: number
    }
  }
