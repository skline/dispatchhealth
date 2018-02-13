connection: "dashboard"

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

explore: care_requests {

  access_filter: {
    field: markets.name
    user_attribute: "market_name"
  }

  join: credit_cards {
    relationship: many_to_one
    sql_on: ${care_requests.id} = ${credit_cards.care_request_id} ;;
  }

  join: shift_teams {
    relationship: many_to_one
    sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  }

  join: shift_team_members {
    relationship: many_to_one
    sql_on: ${shift_team_members.shift_team_id} = ${shift_teams.id} ;;
  }

  join: users {
    relationship: one_to_one
    sql_on:  ${shift_team_members.user_id} = ${users.id};;
  }

  join: provider_profiles {
    relationship: one_to_one
    sql_on: ${provider_profiles.user_id} = ${users.id} ;;
  }

#
#   join: care_request_providers {
#     relationship: one_to_many
#     sql_on: ${care_requests.id} = ${care_request_providers.care_request_id} ;;
#   }

  join: markets {
    relationship: one_to_one
    sql_on: ${care_requests.market_id} = ${markets.id} ;;
  }

  join: care_request_complete{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_complete.care_request_id} = ${care_requests.id} and ${care_request_complete.name}='complete';;
  }

  join: care_request_requested{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_requested.care_request_id} = ${care_requests.id} and ${care_request_requested.name}='requested';;
  }

  join: care_request_accepted{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_accepted.care_request_id} = ${care_requests.id} and ${care_request_accepted.name}='accepted';;
  }


#   join: user_roles {
#     relationship: one_to_one
#     sql_on: ${users.id} = ${user_roles.user_id} ;;
#   }
#
#   join: roles {
#     relationship: one_to_one
#     sql_on: ${user_roles.role_id} = ${roles.id} ;;
#   }
}

  # join: shift_teams {
  #   relationship: one_to_one
  #   sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  # }

  # join: shift_team_members {
  #   relationship: one_to_many
  #   sql_on:  ${shift_teams.id} = ${shift_team_members.shift_team_id};;
  # }