view: sf_markets_mapping {
  derived_table: {
    sql:
    select sf.market, m.id as market_id
from
(select sf_accounts.market
from looker_scratch.sf_accounts
group by 1
union all
select 'Denver, CO'
union all
select 'Phoenix, AZ'
union all
select 'Dallas, TX') sf
left join public.markets m
on  lower(sf.market) like  concat('%', lower(m.name),'%')

;;
    sql_trigger_value: SELECT count(*) FROM looker_scratch.sf_accounts ;;
    indexes: ["market_id", "market"]
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.market ;;
  }


  }
