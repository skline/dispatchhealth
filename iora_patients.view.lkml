view: iora_patients {
  sql_table_name: looker_scratch.iora_patients ;;

  dimension_group: dob {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.dob ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: pcp {
    type: string
    sql: ${TABLE}.pcp ;;
  }

  dimension: practice_name {
    type: string
    sql: ${TABLE}.practice_name ;;
  }

  measure: count {
    type: count
    drill_fields: [first_name, last_name, practice_name]
  }
}
