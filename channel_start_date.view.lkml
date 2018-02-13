view: channel_start_date {
  derived_table: {
    sql: select *
      from
      (select vf.market_dim_id, vf.channel_dim_id,
      CAST(DATE_FORMAT(min(vf.local_requested_time) ,'%Y-%m-01 00:00:00') as DATETIME) as first_accepted_time
from jasperdb.visit_facts vf
join jasperdb.channel_dimensions cd
on cd.id=vf.channel_dim_id
group by 1,2) ed_diversion_survey_response_rate
             ;;

      sql_trigger_value: SELECT CURDATE() ;;
      indexes: ["market_dim_id", "channel_dim_id"]
    }

  dimension: market_dim_id {
      type: number
      sql: ${TABLE}.market_dim_id ;;
    }

  dimension: channel_dim_id {
    type: number
    sql: ${TABLE}.channel_dim_id ;;
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.market_dim_id, ${TABLE}.channel_dim_id) ;;
  }

  dimension_group: first_accepted {
    type: time
    convert_tz: no
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.first_accepted_time ;;
  }


}
