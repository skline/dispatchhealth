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
}
