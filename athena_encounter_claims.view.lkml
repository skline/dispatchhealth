view: athena_encounter_claims {
   derived_table: {
     sql: SELECT ace.appointment_id, ace.clinical_encounter_id, ac.claim_id
          FROM athenadwh_clinical_encounters ace
          JOIN athenadwh_claims ac ON ace.appointment_id = ac.claim_appointment_id
       ;;
    sql_trigger_value: SELECT CURDATE() ;;
    indexes: ["appointment_id", "clinical_encounter_id", "claim_id"]
   }

   dimension: appointment_id {
     description: "The Athena appointment ID"
     primary_key: yes
     type: number
     sql: ${TABLE}.appointment_id ;;
   }

   dimension: clinical_encounter_id {
     description: "The Athena internal ID for a clinical encounter"
     type: number
     sql: ${TABLE}.clinical_encounter_id ;;
   }

   dimension: claim_id {
    description: "The Athena claim ID for a clinical encounter"
    type: number
    sql: ${TABLE}.claim_id ;;
  }

}
