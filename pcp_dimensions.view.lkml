view: pcp_dimensions {
  sql_table_name: jasperdb.pcp_dimensions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: pcp_name {
    type: string
    sql: ${TABLE}.pcp_name ;;
  }

  dimension: pcp_phone {
    type: string
    sql: ${TABLE}.pcp_phone ;;
  }

  dimension_group: updated {
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, pcp_name]
  }
}
