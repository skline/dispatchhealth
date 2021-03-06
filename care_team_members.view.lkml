view: care_team_members {
  sql_table_name: public.care_team_members ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: class_id {
    type: string
    sql: ${TABLE}.class_id ;;
  }

  dimension: clinical_provider_id {
    type: string
    sql: ${TABLE}.clinical_provider_id ;;
  }

  dimension: consent_not_received {
    type: yesno
    sql: ${TABLE}.consent_received IS FALSE ;;
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

  dimension: fax {
    type: string
    sql: ${TABLE}.fax ;;
  }

  dimension: member_id {
    type: string
    sql: ${TABLE}.member_id ;;
  }

  dimension: name {
    type: string
    sql: INITCAP(${TABLE}.name) ;;
  }

  dimension: care_team_exists {
    type: yesno
    sql: ${name} IS NOT NULL ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: provider_type {
    type: string
    sql: ${TABLE}.provider_type ;;
  }

  dimension: pcp_provider_flag {
    type: yesno
    sql: ${provider_type} = 'Primary Care Provider' ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: send_automatically {
    type: yesno
    sql: ${TABLE}.send_automatically IS TRUE ;;
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

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
