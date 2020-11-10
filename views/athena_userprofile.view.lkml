view: athena_userprofile {
  sql_table_name: athena.userprofile ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}."id" ;;
  }

  dimension: __batch_id {
    type: string
    hidden: yes
    sql: ${TABLE}."__batch_id" ;;
  }

  dimension_group: __file {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    hidden: yes
    sql: ${TABLE}."__from_file" ;;
  }

  dimension: block_account_flag {
    type: yesno
    hidden: yes
    sql: ${TABLE}."block_account_flag" ;;
  }

  dimension: block_account_reason {
    type: string
    hidden: yes
    sql: ${TABLE}."block_account_reason" ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
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

  dimension_group: created_datetime {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."created_datetime" ;;
  }

  dimension_group: deleted_datetime {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."deleted_datetime" ;;
  }

  dimension: department_name {
    type: string
    sql: ${TABLE}."department_name" ;;
  }

  dimension_group: dob {
    type: time
    hidden: yes
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."dob" ;;
  }

  dimension: email {
    type: string
    hidden: yes
    sql: ${TABLE}."email" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."first_name" ;;
  }

  dimension_group: last_login {
    type: time
    hidden: yes
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."last_login_date" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."last_name" ;;
  }

  dimension: notes {
    type: string
    hidden: yes
    sql: ${TABLE}."notes" ;;
  }

  dimension: ssn {
    type: string
    hidden: yes
    sql: ${TABLE}."ssn" ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
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

  dimension_group: user_context_deleted_by {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."user_context_deleted_by" ;;
  }

  dimension_group: user_context_deleted_datetime {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."user_context_deleted_datetime" ;;
  }

  dimension: user_context_id {
    type: string
    hidden: yes
    sql: ${TABLE}."user_context_id" ;;
  }

  dimension: user_position {
    type: string
    sql: ${TABLE}."user_position" ;;
  }

  dimension: user_profile_id {
    type: number
    hidden: yes
    sql: ${TABLE}."user_profile_id" ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}."username" ;;
  }

}
