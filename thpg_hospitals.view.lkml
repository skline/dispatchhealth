view: thpg_hospitals {
  sql_table_name: looker_scratch.thpg_hospitals ;;

  dimension: hospital_long {
    type: string
    sql: ${TABLE}.hospital_long ;;
  }

  dimension: hospital_short {
    type: string
    sql: ${TABLE}.hospital_short ;;
  }

  dimension: map_code {
    type: string
    sql: ${TABLE}.map_code ;;
  }

  dimension: zcomma {
    type: string
    sql: ${TABLE}.zcomma ;;
  }

  dimension: zip_code {
    type: zipcode
    sql: left(${TABLE}.zip_code,5) ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
