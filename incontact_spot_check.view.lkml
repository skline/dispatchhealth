view: incontact_spot_check {
  sql_table_name: looker_scratch.incontact_spot_check ;;

  dimension: care_request {
    type: yesno
    sql: ${TABLE}.care_request ;;
  }

  dimension: incontact_contact_id {
    type: number
    sql: ${TABLE}.incontact_contact_id ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}.notes ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: count_distinct {
    type: number
    sql: count(distinct ${incontact_contact_id});;
  }
}
