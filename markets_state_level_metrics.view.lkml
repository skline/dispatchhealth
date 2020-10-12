view: markets_state_level_metrics {

derived_table: {
      sql:
  select
    distinct state,
    min(market_start) as min_market_start,
    count(*) as count_markets_in_state

  from
   (
    select
    name,
    state,
    market_start

  from markets m
  left join market_start_date ms on ms.market_id = m.id) minms
  group by state
  ;;

  sql_trigger_value: SELECT MAX(created_at) FROM markets ;;
  indexes: ["state"]
    }

dimension: state {
  primary_key: yes
  description: "Market State"
  type: string
  sql: ${TABLE}.state ;;
}

dimension_group: min_market_start {
  description: "Date the first market started/opened in the state"
  type: time
  timeframes: [
    raw,
    date,
    week,
    month,
    quarter,
    year
  ]
  sql: ${TABLE}.min_market_start ;;
}


  measure: count_market_states {
    description: "Counts the number of distinct market States"
    hidden: no
    type: count
    drill_fields: []
  }
}
