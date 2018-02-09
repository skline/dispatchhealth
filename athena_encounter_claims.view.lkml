# view: athena_encounter_claims {
  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
# }

view: athena_encounter_claims {
   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: SELECT ace.appointment_id, ace.clinical_encounter_id, ac.claim_id
          FROM athenadwh_clinical_encounters ace
          JOIN athenadwh_claims ac ON ace.appointment_id = ac.claim_appointment_id
       ;;
    sql_trigger_value: SELECT CURDATE() ;;
    indexes: ["appointment_id", "clinical_encounter_id", "claim_id"]
   }

   # Define your dimensions and measures here, like this:
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

#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
}
