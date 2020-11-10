view: corhio {
  sql_table_name: corhio.corhio ;;

  dimension: messageid {
    primary_key: yes
    type: number
    value_format_name: id
    sql: ${TABLE}."messageid" ;;
  }

  dimension_group: __file {
    type: time
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
    sql: ${TABLE}."__file_date" ;;
  }

  dimension: __from_file {
    type: string
    sql: ${TABLE}."__from_file" ;;
  }

  dimension_group: __processed {
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
    sql: ${TABLE}."__processed_date" ;;
  }

  dimension: admissiontype {
    type: string
    sql: ${TABLE}."admissiontype" ;;
  }

  dimension_group: admit {
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
    sql: ${TABLE}."admitdatetime" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension_group: createddate {
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
    sql: ${TABLE}."createddate" ;;
  }

  dimension: datasender {
    type: string
    sql: ${TABLE}."datasender" ;;
  }

  dimension: datasenderlongname {
    type: string
    sql: ${TABLE}."datasenderlongname" ;;
  }

  dimension: death {
    type: string
    sql: ${TABLE}."death" ;;
  }

  dimension_group: deathdatetime {
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
    sql: ${TABLE}."deathdatetime" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: diagnosis {
    type: string
    sql: ${TABLE}."diagnosis" ;;
  }

  dimension_group: dischargedatetime {
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
    sql: ${TABLE}."dischargedatetime" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: dischargedisposition {
    type: string
    sql: ${TABLE}."dischargedisposition" ;;
  }

  dimension: dischargelocation {
    type: string
    sql: ${TABLE}."dischargelocation" ;;
  }

  dimension_group: dob {
    type: time
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

  dimension: encounterlocation {
    type: string
    sql: ${TABLE}."encounterlocation" ;;
  }

  dimension: ethnicity {
    type: string
    sql: ${TABLE}."ethnicity" ;;
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}."firstname" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."gender" ;;
  }

  dimension: hospitalservice {
    type: string
    sql: ${TABLE}."hospitalservice" ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}."lastname" ;;
  }

  dimension: maritalstatus {
    type: string
    sql: ${TABLE}."maritalstatus" ;;
  }

  dimension: member_id {
    type: number
    sql: ${TABLE}."member_id" ;;
  }

  dimension_group: messagedate {
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
    sql: ${TABLE}."messagedate" AT TIME ZONE 'UTC' AT TIME ZONE ${timezones.pg_tz};;
  }

  dimension: messagetype {
    type: string
    sql: ${TABLE}."messagetype" ;;
  }

  dimension: middlename {
    type: string
    sql: ${TABLE}."middlename" ;;
  }

  dimension: msgevent {
    type: string
    sql: ${TABLE}."msgevent" ;;
  }

  dimension: patientclass {
    type: string
    sql: ${TABLE}."patientclass" ;;
  }

  dimension: patienttype {
    type: string
    sql: ${TABLE}."patienttype" ;;
  }

  dimension: pcpfirstname {
    type: string
    sql: ${TABLE}."pcpfirstname" ;;
  }

  dimension: pcplastname {
    type: string
    sql: ${TABLE}."pcplastname" ;;
  }

  dimension: phonehome {
    type: number
    sql: ${TABLE}."phonehome" ;;
  }

  dimension: primarylanguage {
    type: string
    sql: ${TABLE}."primarylanguage" ;;
  }

  dimension: race {
    type: string
    sql: ${TABLE}."race" ;;
  }

  dimension: reasonforvisit {
    type: string
    sql: ${TABLE}."reasonforvisit" ;;
  }

  dimension: threadid {
    type: number
    value_format_name: id
    sql: ${TABLE}."threadid" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: 12_hour_corhio_admit_emergency {
    description: "Emergency admittance recorded by CORHIO within 12 hours of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 12 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${admissiontype}) = 'e';;
    group_label: "Emergency Admittance Intervals"
  }

  dimension: 3_day_corhio_admit_emergency {
    description: "Emergency admittance recorded by CORHIO within 3 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 72 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${admissiontype}) = 'e';;
    group_label: "Emergency Admittance Intervals"
  }

  dimension: 7_day_corhio_admit_emergency {
    description: "Emergency admittance recorded by CORHIO within 7 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 168 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${admissiontype}) = 'e';;
    group_label: "Emergency Admittance Intervals"
  }

  dimension: 14_day_corhio_admit_emergency {
    description: "Emergency admittance recorded by CORHIO within 14 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 336 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${admissiontype}) = 'e';;
    group_label: "Emergency Admittance Intervals"
  }

  dimension: 30_day_corhio_admit_emergency {
    description: "Emergency admittance recorded by CORHIO within 30 days of the DH care request on-scene date"
    type: yesno
    sql: ((EXTRACT(EPOCH FROM ${admit_raw})-EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw})) / 3600) <= 720 and EXTRACT(EPOCH FROM ${admit_raw}) > EXTRACT(EPOCH FROM ${care_request_flat.on_scene_raw}) and lower(${admissiontype}) = 'e';;
    group_label: "Emergency Admittance Intervals"
  }

  measure: count_12_hour_corhio_admit_emergency {
    description: "Count Emergency admittances recorded by CORHIO within 12 hours of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 12_hour_corhio_admit_emergency
      value: "yes"
    }
    group_label: "Emergency Admittance Intervals"
  }

  measure: count_3_day_corhio_admit_emergency {
    description: "Count Emergency admittances recorded by CORHIO within 3 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 3_day_corhio_admit_emergency
      value: "yes"
    }
    group_label: "Emergency Admittance Intervals"
  }

  measure: count_7_day_corhio_admit_emergency {
    description: "Count Emergency admittances recorded by CORHIO within 7 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 7_day_corhio_admit_emergency
      value: "yes"
    }
    group_label: "Emergency Admittance Intervals"
  }

  measure: count_14_day_corhio_admit_emergency {
    description: "Count Emergency admittances recorded by CORHIO within 14 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 14_day_corhio_admit_emergency
      value: "yes"
    }
    group_label: "Emergency Admittance Intervals"
  }

  measure: count_30_day_corhio_admit_emergency {
    description: "Count Emergency admittances recorded by CORHIO within 30 days of the DH care request on-scene date"
    type: count_distinct
    sql: ${care_request_flat.care_request_id}  ;;
    filters: {
      field: 30_day_corhio_admit_emergency
      value: "yes"
    }
    group_label: "Emergency Admittance Intervals"
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      datasenderlongname,
      lastname,
      firstname,
      middlename,
      pcplastname,
      pcpfirstname
    ]
  }
}
