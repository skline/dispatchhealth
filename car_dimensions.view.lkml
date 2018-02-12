view: car_dimensions {
  label: "Shift Name Dimensions"
  sql_table_name: jasperdb.car_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: car_name {
    label: "Shift Name"
    type: string
    sql: ${TABLE}.car_name ;;
  }

  dimension: smfr_car {
    label: "SMFR car flag"
    type: yesno
    sql: ${car_name} = "SMFR_Car" ;;
  }

  dimension: non_smfr_car {
    label: "Non-SMFR car flag"
    type: yesno
    sql: ${car_name} != "SMFR_Car" ;;
  }

  dimension: non_smfr_billable_visit {
    label: "Non-SMFR billable visit flag"
    type: yesno
    sql: ${visit_facts.billable_visit} AND ${non_smfr_car} ;;
  }

  measure: count_of_non_smfr_billable_visit {
    label: "Non-SMFR billable visit count"
    type: count
    filters: {
      field: non_smfr_billable_visit
      value: "yes"
    }
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
    drill_fields: [id, car_name]
  }
  measure: car_names_concat {
    type:  string
    sql:  GROUP_CONCAT(distinct car_name) ;;
  }
}
