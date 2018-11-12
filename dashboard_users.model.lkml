connection: "dashboard"

include: "*.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

explore: care_requests_user {

  sql_always_where: ${deleted_raw} IS NULL AND
  (${care_request_flat_user.secondary_resolved_reason} NOT IN ('Test Case', 'Duplicate') OR ${care_request_flat_user.secondary_resolved_reason} IS NULL) ;;

  join: care_request_flat_user {
    relationship: one_to_one
    sql_on: ${care_requests_user.id} = ${care_request_flat_user.care_request_id} ;;
  }

#   join: cars_user {
#     relationship: many_to_one
#     sql_on: ${shift_planning_facts_clone.car_dim_id} = ${cars.id} ;;
#   }

  join: channel_items_user {
      relationship: many_to_one
      sql_on:  ${care_requests_user.channel_item_id} = ${channel_items_user.id} ;;
  }

  join: markets_user {
    relationship: many_to_one
    sql_on: ${care_requests_user.market_id} = ${markets_user.id} ;;
  }

  join: patients_user {
    relationship: many_to_one
    sql_on:  ${care_requests_user.patient_id} = ${patients_user.id} ;;
  }

#   join: primary_payer_dimensions_clone_user {
#
#   }

}
