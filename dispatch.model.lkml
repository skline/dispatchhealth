connection: "bi"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

explore: visit_facts {

  access_filter: {
    field: market_dimensions.market_name
    user_attribute: "market_name"
  }

  join: market_dimensions {
    relationship: many_to_one
    sql_on: ${market_dimensions.id} = ${visit_facts.market_dim_id} ;;
  }

  join: channel_dimensions {
    relationship: one_to_many
    sql_on: ${channel_dimensions.id} = ${visit_facts.channel_dim_id} ;;
  }

  join: request_type_dimensions {
    relationship: many_to_one
    sql_on: ${request_type_dimensions.id} = ${visit_facts.request_type_dim_id} ;;
  }

  join: visit_dimensions {
    relationship: many_to_one
    sql_on: ${visit_dimensions.visit_number} = ${visit_facts.visit_dim_number} ;;
  }

  join: car_dimensions {
    relationship: many_to_one
    sql_on: ${car_dimensions.id} = ${visit_facts.car_dim_id} ;;
  }

  join: provider_dimensions {
    relationship: many_to_one
    sql_on: ${provider_dimensions.id} = ${visit_facts.provider_dim_id} ;;
  }

  #Join the subtotaling view using a cross join.
  join: subtotal_over {
    type: cross
    relationship: one_to_many
  }

}
