view: adwords_campaigns_clone {
  sql_table_name: looker_scratch.adwords_campaigns_clone ;;

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: campaign_name {
    type: string
    sql: ${TABLE}.campaign_name ;;
  }

  dimension: campaign_name_lower {
    type: string
    sql: lower(${campaign_name}) ;;
  }

  dimension: market_dim_id {
    type: number
    sql: ${TABLE}.market_dim_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: market_id_new {
    type: number
    sql: case
          when ${campaign_name_lower}  like '%-atl%' then 177
          when ${campaign_name_lower}  like '%-las%' then 162
          when ${campaign_name_lower}  like '%-hou%' then 165
          when ${campaign_name_lower}  like '%-phx%' then 161
          when ${campaign_name_lower}  like '%-por%' then 175
          when ${campaign_name_lower}  like '%-boi%' then 176
          when ${campaign_name_lower}  like '%-njr%' then 171
          when ${campaign_name_lower}  like '%-den%' then 159
          when ${campaign_name_lower}  like '%-dal%' then 169
          when ${campaign_name_lower}  like '%-cos%' then 160
          when ${campaign_name_lower}  like '%-okc%' then 166
          when ${campaign_name_lower}  like '%-tac%' then 170
          when ${campaign_name_lower}  like '%-spr%' then 168
          when ${campaign_name_lower}  like '%-spo%' then 173
          when ${campaign_name_lower}  like '%-sea%' then 174
          when ${campaign_name_lower}  like '%-ric%' then 164
          when ${campaign_name_lower}  like '%-oly%' then 172
          when ${campaign_name_lower}  like '%-ftw%' then 178
          else null end;;
  }

  measure: count {
    type: count
    drill_fields: [campaign_name]
  }
}
