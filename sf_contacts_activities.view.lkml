view: sf_contacts_activities {
  sql_table_name: looker_scratch.sf_contacts_activities ;;

  dimension: activity_id {
    type: string
    sql: ${TABLE}."activity_id" ;;
  }

  dimension: contact_id {
    type: string
    sql: ${TABLE}."contact_id" ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
