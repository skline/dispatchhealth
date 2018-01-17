connection: "bi"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

# Select the views that should be a part of this model,
# and define the joins that connect them together.

explore: visits {
  join: markets {
    relationship: many_to_one
    sql_on: ${visits.market_dim_id} = ${markets.id} ;;
  }
}
