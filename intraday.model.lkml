connection: "intraday"

include: "*.view.lkml"                       # include all views in this project
explore:  intraday_shift_teams {

  join: intraday_care_requests {
    sql_on: ${intraday_care_requests.shift_team_id} = ${intraday_shift_teams.shift_team_id}
    and ${intraday_care_requests.accepted_date}=${intraday_shift_teams.start_date}
    and ${intraday_care_requests.updated_raw} > current_date - interval '1 day';;
  }
  join: primary_payer_dimensions_intra {
    sql_on: ${intraday_care_requests.package_id} = ${primary_payer_dimensions_intra.insurance_package_id} ;;
  }
  join: insurance_plans_intra {
    sql_on: ${insurance_plans_intra.package_id} = ${intraday_care_requests.package_id} ;;
  }
  join: insurance_classifications {
    sql_on: ${insurance_classifications.id} = ${insurance_classifications.classification} ;;
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

explore:  intraday_care_requests {
  sql_always_where: ${updated_raw} > current_date - interval '1 day';;
  join: intraday_shift_teams {
    sql_on: ${intraday_care_requests.shift_team_id} = ${intraday_shift_teams.shift_team_id}
      and ${intraday_care_requests.accepted_date}=${intraday_shift_teams.start_date};;
  }
  join: primary_payer_dimensions_intra {
    sql_on: ${intraday_care_requests.package_id} = ${primary_payer_dimensions_intra.insurance_package_id} ;;
  }
  join: insurance_plans_intra {
    sql_on: ${insurance_plans_intra.package_id} = ${intraday_care_requests.package_id} ;;
  }
  join: insurance_classifications {
    sql_on: ${insurance_classifications.id} = ${insurance_classifications.classification} ;;
  }
  join: cars_intra {
    sql_on: ${intraday_shift_teams.car_id} = ${cars_intra.id} ;;
  }
  join: markets_intra {
    sql_on: ${markets_intra.id}= ${intraday_care_requests.market_id} ;;
  }
  join: timezones_intra {
    sql_on: ${markets_intra.sa_time_zone}=${timezones_intra.rails_tz} ;;
  }
}
