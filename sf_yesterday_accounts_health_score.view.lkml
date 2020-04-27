view: sf_yesterday_accounts_health_score{
    derived_table: {
      sql:
          select account_id, health_score, date
from
(select sf_accounts_health_score_historical.account_id, sf_accounts_health_score_historical.health_score, ROW_NUMBER()  OVER (PARTITION BY sf_accounts_health_score_historical.account_id order by
sf_accounts_health_score_historical.date desc) as row_number, date
from  looker_scratch.sf_accounts_health_score_historical
where date <=  current_date - interval '1 days') last_week
where row_number=1


      ;;
      sql_trigger_value: SELECT count(*) FROM looker_scratch.sf_accounts_health_score_historical ;;
      indexes: ["account_id"]
    }
  dimension: account_id {
    type: string
    sql: ${TABLE}.account_id ;;
  }

  dimension: health_score {
    type: number
    sql: ${TABLE}.health_score ;;
  }

  dimension: date {
    type: date
    sql: ${TABLE}.date ;;
  }

}
