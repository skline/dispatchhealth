view: sf_contacts {
  sql_table_name: looker_scratch.sf_contacts ;;

  dimension: account_id {
    type: string
    sql: ${TABLE}."account_id" ;;
  }

  dimension: contact_id {
    type: string
    sql: ${TABLE}."contact_id" ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}."created_by" ;;
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
    sql: ${TABLE}."created_date" ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}."email" ;;
  }

  dimension: invalid_emails {
    type: yesno
    sql: ${email} in('jeannek2@concast.net') ;;
  }

  dimension: full_name {
    type: string
    sql: ${TABLE}."full_name" ;;
  }

  dimension_group: last_activity {
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
    sql: ${TABLE}."last_activity" ;;
  }


  dimension: mobile_phone {
    type: string
    sql: ${TABLE}."mobile_phone" ;;
  }

  dimension: npi_number {
    type: string
    sql: ${TABLE}."npi_number" ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}."phone" ;;
  }

  dimension: relationship {
    type: string
    sql: ${TABLE}."relationship" ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}."title" ;;
  }

  measure: count {
    label: "Count Distinct SF Contacts"
    type: count_distinct
    sql: ${contact_id} ;;
    sql_distinct_key: ${contact_id} ;;
  }
}
