connection: "intraday"

include: "*.view.lkml"                       # include all views in this project
explore:  intraday_shift_teams {

  join: intraday_care_requests {
    sql_on: ${intraday_care_requests.shift_team_id} = ${intraday_shift_teams.shift_team_id}
    and ${intraday_care_requests.accepted_date}=${intraday_shift_teams.start_date};;
  }
  join: primary_payer_dimensions_intra {
    sql_on: ${intraday_care_requests.package_id} = ${primary_payer_dimensions_intra.insurance_package_id} ;;
  }
  join: cars_intra {
    sql_on: ${intraday_shift_teams.car_id} = ${cars_intra.id} ;;
  }
  join: markets_intra {
    sql_on: ${markets_intra.id}= ${cars_intra.market_id} ;;
  }
  join: timezones_intra {
    sql_on: ${markets_intra.sa_time_zone}=${timezones_intra.rails_tz} ;;
  }
}
