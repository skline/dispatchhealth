view: thr_texas_city_segments_by_zip {
  sql_table_name: looker_scratch.thr_texas_city_segments_by_zip ;;
  drill_fields: [id]

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: thr_city {
    type: string
    sql: ${TABLE}."city" ;;
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
    sql: ${TABLE}."created_at" ;;
  }

  dimension: provider_group {
    hidden: yes
    type: string
    sql: ${TABLE}."provider_group" ;;
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
    sql: ${TABLE}."updated_at" ;;
  }

  dimension: zip_code {
    hidden: no
    type: zipcode
    sql: ${TABLE}."zip_code" ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [id]
  }

}
