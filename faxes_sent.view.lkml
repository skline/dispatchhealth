view: faxes_sent {
  sql_table_name: looker_scratch.faxes_sent ;;

  dimension: fax {
    type: number
    sql: ${TABLE}.fax ;;
  }

  dimension: fax_country {
    type: string
    sql: ${TABLE}.fax_country ;;
  }

  dimension: fax_id {
    type: number
    sql: ${TABLE}.fax_id ;;
  }

  dimension_group: sent {
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
    sql: ${TABLE}.sent_date ;;
  }

  measure: count {
    label: "Interfaxes Sent"
    type: number
    sql:  count(distinct ${fax_id}) ;;

  }
}
