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

  join: cars {
    relationship: many_to_one
    sql_on: ${shift_teams.car_id} = ${cars.id} ;;
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

  join: care_request_archived{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='archived';;
  }

  join: care_request_scheduled{
    relationship: one_to_many
    from: care_request_statuses
    sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
  }


  join: budget_projections_by_market_clone {
    sql_on: ${care_requests.market_id} = ${budget_projections_by_market_clone.market_dim_id}
      AND ${care_request_complete.created_mountain_month}=${budget_projections_by_market_clone.month_month};;
  }

  join: patients {
    sql_on:  ${patients.id} =${care_requests.patient_id} ;;
  }

  join: power_of_attorneys {
    sql_on:  ${patients.id} =${power_of_attorneys.patient_id} ;;
  }

  join: channel_items {
    sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
  }

  join: invoca_clone {
    sql_on: REPLACE(${power_of_attorneys.phone}, '-', '') like  CONCAT('%', ${invoca_clone.caller_id} ,'%')
            OR ${patients.mobile_number} like CONCAT('%', ${invoca_clone.caller_id} ,'%')
            OR ${users.mobile_number} like CONCAT('%', ${invoca_clone.caller_id} ,'%')
            and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < 86400
            ;;

    }

  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
       and ${invoca_clone.caller_id}::text like  CONCAT('%', ${incontact_clone.from_number} ,'%')
            ;;
  }

  join: incontact_spot_check_by_market {
    sql_on: ${incontact_spot_check_by_market.market_id} = ${markets.id} and ${care_request_requested.created_date}=${incontact_spot_check_by_market.date_call}
            ;;
  }
  join: shift_hours_by_day_market_clone {
    sql_on:  ${markets.name} = ${shift_hours_by_day_market_clone.market_name}
    and ${care_request_complete.created_mountain_date} = ${shift_hours_by_day_market_clone.date_date};;
  }

  join: shift_hours_market_month {
    from: shift_hours_by_day_market_clone
    sql_on:  ${markets.name} = ${shift_hours_market_month.market_name}
      and ${care_request_complete.created_mountain_month} = ${shift_hours_market_month.date_month};;
  }





 }
  explore: invoca_clone {


  join: incontact_clone {
    sql_on: abs(EXTRACT(EPOCH FROM ${incontact_clone.end_time_raw})-EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw}+${invoca_clone.total_duration})) < 10
       and ${invoca_clone.caller_id}::text like  CONCAT('%', ${incontact_clone.from_number} ,'%')
            ;;
    }
    join: patient_user_poa {
      sql_on:  REPLACE(${patient_user_poa.poa_number}, '-', '') like  CONCAT('%', ${invoca_clone.caller_id} ,'%')
            OR ${patient_user_poa.patient_number} like CONCAT('%', ${invoca_clone.caller_id} ,'%')
            OR ${patient_user_poa.user_number} like CONCAT('%', ${invoca_clone.caller_id} ,'%')
             ;;
    }
    join: patients {
      sql_on:  ${patients.id} = ${patient_user_poa.patient_id}  ;;
    }

    join: care_requests {
      sql_on: ${patients.id} = ${care_requests.patient_id}
                 and abs(EXTRACT(EPOCH FROM ${invoca_clone.start_time_raw})-EXTRACT(EPOCH FROM ${care_requests.created_mountain_raw})) < 86400 ;;
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

    join: care_request_archived{
      relationship: one_to_many
      from: care_request_statuses
      sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='archived';;
    }

    join: care_request_scheduled{
      relationship: one_to_many
      from: care_request_statuses
      sql_on: ${care_request_archived.care_request_id} = ${care_requests.id} and ${care_request_archived.name}='scheduled';;
    }

    join: channel_items {
      sql_on:  ${channel_items.id} =${care_requests.channel_item_id} ;;
    }

    join: markets {
      sql_on:  ${markets.id} =${invoca_clone.market_id} ;;
    }

    join: incontact_spot_check_clone {
      sql_on: ${incontact_spot_check_clone.incontact_contact_id} = ${incontact_clone.contact_id}
        ;;
    }





}

explore: zipcodes {
  join: markets {
    sql_on: ${zipcodes.market_id} = ${markets.id} ;;
  }
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


  # join: shift_teams {
  #   relationship: one_to_one
  #   sql_on: ${care_requests.shift_team_id} = ${shift_teams.id} ;;
  # }

  # join: shift_team_members {
  #   relationship: one_to_many
  #   sql_on:  ${shift_teams.id} = ${shift_team_members.shift_team_id};;
  # }
