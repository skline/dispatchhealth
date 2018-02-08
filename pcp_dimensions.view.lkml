view: pcp_dimensions {
  label: "PCP Dimensions"
  sql_table_name: jasperdb.pcp_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    hidden: yes
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
    label: "PCP Name"
    type: string
    sql: ${TABLE}.pcp_name ;;
  }

  dimension: pcp_phone {
    label: "PCP Phone"
    type: string
    sql: ${TABLE}.pcp_phone ;;
  }

  dimension_group: updated {
    hidden: yes
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
