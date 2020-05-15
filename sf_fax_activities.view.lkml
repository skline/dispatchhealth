view: sf_fax_activities {
  derived_table: {
    explore_source: sf_contacts {
      column: contact_id { field: sf_contacts_activities.contact_id }
      column: activity_id { field: explicit_activities.activity_id }
      column: start_time { field: explicit_activities.start_time }
      filters: {
        field: sf_contacts_activities.contact_id
        value: "-NULL"
      }
      filters: {
        field: explicit_activities.fax
        value: "Yes"
      }
    }
  }
  dimension: contact_id {}
  dimension: activity_id {}
  dimension: start_time {
    type: date_time
  }

  dimension: after_fax {
    type: yesno
    sql: ${care_request_flat.on_scene_time} >= ${start_time} ;;
  }
}
