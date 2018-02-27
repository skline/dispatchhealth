view: incontact_spot_check_clone {
  sql_table_name: looker_scratch.incontact_spot_check_clone ;;

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

  measure: count_distinct_care_requests {
    type: number
    sql: count(distinct (case when care_request is true then ${incontact_contact_id} else null end));;
  }
}
