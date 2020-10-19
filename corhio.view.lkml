view: corhio {
  sql_table_name: corhio.corhio ;;

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

  dimension_group: admitdatetime {
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
    sql: ${TABLE}."admitdatetime" ;;
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
    sql: ${TABLE}."deathdatetime" ;;
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
    sql: ${TABLE}."dischargedatetime" ;;
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
    sql: ${TABLE}."messagedate" ;;
  }

  dimension: messageid {
    type: number
    value_format_name: id
    sql: ${TABLE}."messageid" ;;
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
