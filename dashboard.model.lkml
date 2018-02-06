connection: "dashboard"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: care_requests {

  access_filter: {
    field: markets.name
    user_attribute: "market_name"
  }

  join: credit_cards {
    relationship: many_to_one
    sql_on: ${care_requests.id} = ${credit_cards.care_request_id} ;;
  }

  join: markets {
    relationship: many_to_one
    sql_on: ${care_requests.market_id} = ${markets.id} ;;
  }
}
