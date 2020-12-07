view: service_lines_intra {
  sql_table_name: public.service_lines_intra ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: followup_14_30_day {
    type: yesno
    sql: ${TABLE}."followup_14_30_day" ;;
  }

  dimension: followup_3_day {
    type: yesno
    sql: ${TABLE}."followup_3_day" ;;
  }

  dimension: is_911 {
    type: yesno
    sql: ${TABLE}."is_911" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: out_of_network_insurance {
    type: yesno
    sql: ${TABLE}."out_of_network_insurance" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
