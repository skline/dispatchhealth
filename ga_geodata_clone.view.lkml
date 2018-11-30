view: ga_geodata_clone {
  sql_table_name: looker_scratch.ga_geodata_clone ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.client_id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: metro {
    type: string
    sql: ${TABLE}.metro ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}.sessions ;;
  }

  dimension_group: timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  dimension: market_id {
    type: number
    sql:case
          when ${metro} in ('Denver CO') then 159
          when ${metro} in ('Colorado Springs-Pueblo CO') then 160
          when ${metro} in ('Phoenix AZ') then 161
          when ${metro} in ('Richmond-Petersburg VA', 'Washington DC (Hagerstown MD)') then 164
          when ${metro} in ('Las Vegas NV') then 162
          when ${metro} in ('Houston TX') then 165
          when ${metro} in ('Oklahoma City OK') then 166
          when ${metro} in ('Seattle-Tacoma WA') then 170
          when ${metro} in ('Dallas-Ft. Worth TX') then 169
          when ${metro} in ('Springfield-Holyoke MA') then 168
        else null end
        ;;
  }
}
