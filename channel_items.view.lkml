include: "channel_items_user.view.lkml"

view: channel_items {
  extends: [channel_items_user]

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: agreement {
    type: yesno
    sql: ${TABLE}.agreement ;;
  }

  dimension: blended_bill {
    type: yesno
    sql: ${TABLE}.blended_bill ;;
  }

  dimension: blended_description {
    type: string
    sql: ${TABLE}.blended_description ;;
  }

  dimension: case_policy_number {
    type: string
    sql: ${TABLE}.case_policy_number ;;
  }

  dimension: channel_id {
    type: number
    sql: ${TABLE}.channel_id ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: contact_person {
    type: string
    sql: ${TABLE}.contact_person ;;
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

  dimension_group: deactivated {
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
    sql: ${TABLE}.deactivated_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: emr_provider_id {
    type: string
    sql: ${TABLE}.emr_provider_id ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
  }

  dimension: preferred_partner {
    type: yesno
    sql: ${TABLE}.preferred_partner ;;
  }

  dimension: preferred_partner_description {
    type: string
    sql: ${TABLE}.preferred_partner_description ;;
  }

  dimension: send_clinical_note {
    type: yesno
    sql: ${TABLE}.send_clinical_note IS TRUE ;;
  }

  dimension: send_note_automatically {
    type: yesno
    sql: ${TABLE}.send_note_automatically IS TRUE ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
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

  dimension: zipcode {
    type: zipcode
    sql: ${TABLE}.zipcode ;;
  }

  dimension: zipcode_short {
    type: zipcode
    sql: left(${zipcode},5) ;;
  }

  dimension: digital_bool_self_report {
    type: yesno
    sql:  ${name} in('Google or other search', 'Social Media (Facebook, LinkedIn, Twitter, Instagram)', 'Social Media(Facebook, LinkedIn, Twitter, Instagram)')


;;
  }


  dimension: digital_bool {
    type:  yesno
    sql: ${ga_pageviews_clone.source_final} is not null or ${web_ga_pageviews_clone.source_final} is not null;;
  }
  dimension: channel_name_fixed {
    type: string
    sql:  case when trim(lower(${name})) in('social media (facebook, linkedin, twitter, instagram)', 'social media(facebook, linkedin, twitter, instagram)') then 'Social Media (Facebook, LinkedIn, Twitter, Instagram)'
          else ${name} end;;
  }
  measure: count {
    type: count
    drill_fields: [id, name, source_name, type_name]
  }

  dimension: non_dtc_self_report {
    type: yesno
    sql:${type_name} in('Senior Care', 'Hospice & Palliative Care', 'SNF' , 'Home Health', 'Health System', 'Employer', 'Payer', 'Provider Group')
    OR ${name} in('Employer', 'Employer Organization', 'Health Insurance Company', '911 Channel', 'West Metro Fire Rescue', 'South Metro Fire Rescue', 'Healthcare provider', 'Healthcare Provider')
    OR (${name} = 'Family or friend' and  ${dtc_ff_patients.patient_id} is null and ${ga_pageviews_full_clone.high_level_category} is null)  ;;

  }

  dimension: high_level_category {
    type: string
    sql: case
         when  (${type_name} is null and lower(${name}) not in('family or friend', 'healthcare provider', 'healthcare provider', 'employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue'))  then 'Direct to Consumer'
          when lower(${type_name}) in('senior care', 'hospice & palliative care', 'snf' , 'home health') or  lower(${name}) in('healthcare provider', 'healthcare provider')  then 'Senior Care'
          when lower(${type_name}) in('health system', 'employer', 'payer', 'provider group', 'injury finance') or lower(${name}) in('employer', 'employer organization', 'health insurance company', '911 channel', 'west metro fire rescue', 'south metro fire rescue') then 'Strategic'          when ${digital_bool} then 'Direct to Consumer'
          when ${dtc_ff_patients.patient_id} is not null then 'Direct to Consumer'
          when lower(${name}) ='family or friend' then 'Family or Friends'
          when ${name} is null then 'No Channel'
        else concat(coalesce(${type_name}, 'Direct'), ': ', ${name}) end;;
  }


}
