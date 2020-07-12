view: patients_mobile {
    derived_table: {
      explore_source: patients {
        column: patient_id {field: patients.id}
        column: mobile_number {}
        filters: {
          field: patients.mobile_number
          value: "-NULL"
        }
      }
      sql_trigger_value:  SELECT MAX(care_request_id) FROM ${care_request_flat.SQL_TABLE_NAME} where created_date > current_date - interval '2 days';;
      indexes: ["patient_id", "mobile_number"]
    }
    dimension: patient_id {
      type: number
    }
    dimension: mobile_number {}
  }
