view: provider_profiles {
  sql_table_name: public.provider_profiles ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: app_key {
    type: string
    sql: ${TABLE}.app_key ;;
  }

  dimension: auth_key {
    type: string
    sql: ${TABLE}.auth_key ;;
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

  dimension: credentials {
    type: string
    sql: ${TABLE}.credentials ;;
  }

  dimension: enc_key {
    type: string
    sql: ${TABLE}.enc_key ;;
  }

  dimension: license_number {
    type: string
    sql: ${TABLE}.license_number ;;
  }

  dimension: license_state {
    type: string
    sql: ${TABLE}.license_state ;;
  }

  dimension: npi {
    type: string
    sql: ${TABLE}.npi ;;
  }

  dimension: thpg_provider {
    type: yesno
    sql: ${thpg_provider.npi} IS NOT NULL ;;
  }

  dimension: position {
    type: string
    sql: ${TABLE}.position ;;
  }

  dimension: provider_image_url {
    type: string
    sql: ${TABLE}.provider_image ;;
  }

  dimension: image_file {
  sql: ('https://s3-us-west-2.amazonaws.com/dispatchhealthimages/uploads/provider_profile/provider_image/'||${id}||${provider_image_url}) ;;
  }

  dimension: provider_image {
    sql: ${image_file};;
    html: <img src="{{ value }}" width="80" height="100"/> ;;
  }

  dimension: provider_image_processing {
    type: yesno
    sql: ${TABLE}.provider_image_processing ;;
  }

  dimension: u_fname {
    type: string
    sql: ${TABLE}.u_fname ;;
  }

  dimension: u_lname {
    type: string
    sql: ${TABLE}.u_lname ;;
  }

  dimension: u_login {
    type: string
    sql: ${TABLE}.u_login ;;
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

  dimension: emt_flag {
    type: yesno
    sql: ${TABLE}.position = 'emt' ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }
  dimension: position_and_name{
    type: string
    sql:  concat(${position}, ': ', ${users.first_name}, ' ', ${users.last_name});;
  }


  measure: count {
    type: count
    drill_fields: [id, u_fname, u_lname]
  }
}
