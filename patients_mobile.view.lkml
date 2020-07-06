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
      sql_trigger_value:  SELECT FLOOR(EXTRACT(epoch from NOW()) / (2*60*60));;
      indexes: ["patient_id", "mobile_number"]
    }
    dimension: patient_id {
      type: number
    }
    dimension: mobile_number {}
  }
