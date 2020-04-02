view: cars {
  sql_table_name: public.cars ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: base_location_id {
    type: number
    hidden: yes
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
    hidden: yes
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

  dimension: smfr_wmfr_other {
    description: "Car names broken out by SMFR, WMFR or Other"
    type: string
    sql: CASE
          WHEN ${name} IS NULL THEN NULL
          WHEN ${name} LIKE '%SMFR%' THEN 'SMFR'
          WHEN ${name} LIKE '%WMFR%' THEN 'WMFR'
          ELSE 'Other'
        END ;;
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

  dimension: advanced_care_car  {
    type: yesno
    sql: lower(${name}) like '%advanced%' ;;
  }

  dimension: telemedicine_car  {
    type: yesno
    sql: lower(${name}) like '%virtual%' ;;
  }


  dimension: mfr_flex_car  {
    type: yesno
    sql: ${name} like '%MFR%' OR ${name} LIKE '%Flex%' ;;
  }

  dimension: test_car  {
    type: yesno
    sql: lower(${name}) like '%test%' ;;
  }
  measure: count_distinct_cars {
    description: "Count of distinct cars, not including SMFR/WMFR/Flex/Virtual/Advanced"
    type: count_distinct
    sql: ${name} ;;
    filters: {
      field: mfr_flex_car
      value: "no"
    }
    filters: {
      field: advanced_care_car
      value: "no"
    }
    filters: {
      field: telemedicine_car
      value: "no"
    }
  }

  dimension: car_lending_flag {
    description: "Identifies cars where the care request market differs from the car's home market"
    type: yesno
    sql: ${care_requests.market_id} != ${cars.market_id} ;;
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

  measure: car_names_aggregated {
    type: string
    sql: array_agg(distinct ${name}) ;;
    }
}
