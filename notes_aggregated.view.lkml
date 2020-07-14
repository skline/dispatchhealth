view: notes_aggregated {

  derived_table: {
    sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
    indexes: ["care_request_id"]
    explore_source: care_requests {
      column: notes_aggregated { field: notes.notes_aggregated }
      column: care_request_id { field: care_request_flat.care_request_id }
    }
  }
  dimension: notes_aggregated {
    type: string
  }
  dimension: care_request_id {
    type: number
  }

}
