view: shift_team_visits {
  derived_table: {
    sql:
    SELECT  DISTINCT
        cr.id AS care_request_id,
        DATE(MIN(crs.started_at) AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz) AS complete_date,
        cr.shift_team_id,
        st.car_id,
        cr.market_id,
        m.name as market_name,
        tz.pg_tz,
        stm.user_id,
        u.first_name,
        u.last_name
        FROM care_requests cr
        JOIN care_request_statuses crs
        ON cr.id = crs.care_request_id AND crs.name = 'complete'
        LEFT JOIN shift_teams st
        ON cr.shift_team_id = st.id
        LEFT JOIN shift_team_members stm
        ON stm.shift_team_id = cr.shift_team_id
        JOIN users u
        ON u.id = stm.user_id
        JOIN markets m
        ON cr.market_id = m.id
        JOIN looker_scratch.timezones tz
        ON m.sa_time_zone = tz.rails_tz
        GROUP BY 1,3,4,5,6,7,8,9,10
        ORDER BY 1 DESC, 4,3 ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension_group: complete_date {
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
    sql: ${TABLE}.complete_date ;;
  }

  dimension: shift_team_id {
    type: number
    sql: ${TABLE}.shift_team_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: car_id {
    type: number
    sql: ${TABLE}.car_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: market_name {
    type: string
    sql: ${TABLE}.market_name ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: pg_tz {
    type: string
    hidden: yes
    sql: ${TABLE}.pg_tz ;;
  }

  measure: count_complete_visits {
    type: count_distinct
    sql: ${care_request_id} ;;
  }

}
