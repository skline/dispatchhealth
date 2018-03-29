view: cars {
  sql_table_name: public.cars ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: base_location_id {
    type: number
    sql: ${TABLE}.base_location_id ;;
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

  dimension: last_location_id {
    type: number
    sql: ${TABLE}.last_location_id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
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
  dimension: arm_car  {
    type: yesno
    sql: ${name} like '%SMFR_Car%' ;;
  }
  measure: emt_car_staff {
    type: string
    sql:  max(case when provider_profiles.position ='emt' then concat(${users.first_name},' ',${users.last_name})  else null end);;
  }

  measure: app_car_staff {
    type: string
    sql:  max(case when provider_profiles.position ='advanced practice provider' then concat(${users.first_name},' ',${users.last_name})  else null end);;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
