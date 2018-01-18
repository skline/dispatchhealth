view: car_dimensions {
  sql_table_name: jasperdb.car_dimensions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: car_name {
    type: string
    sql: ${TABLE}.car_name ;;
  }

  dimension: smfr_car {
    type: yesno
    sql: ${car_name} = "SMFR_Car" ;;
  }

  dimension: non_smfr_car {
    type: yesno
    sql: ${car_name} != "SMFR_Car" ;;
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
    drill_fields: [id, car_name]
  }
}
