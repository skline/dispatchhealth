view: markets_intra {
  sql_table_name: looker_scratch.markets_intra ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    type: string
    sql: case when ${cars_intra.name} = 'SMFR_Car' then 'South Metro Fire Rescue'
         else ${TABLE}.name end ;;
  }

  dimension: sa_time_zone {
    type: string
    sql: ${TABLE}.sa_time_zone ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
