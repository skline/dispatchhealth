view: channel_items {
  sql_table_name: public.channel_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

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

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
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

  dimension: source_name {
    type: string
    sql: ${TABLE}.source_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: type_name {
    type: string
    sql: ${TABLE}.type_name ;;
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

  dimension: digital_bool {
    type: yesno
    sql:  ${name} in('Google or other search', 'Social Media (Facebook, LinkedIn, Twitter, Instagram)', 'Social Media(Facebook, LinkedIn, Twitter, Instagram)')
           OR (${ga_pageviews_clone.source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com', 'facebook', 'instagram'))
           OR lower(${ga_pageviews_clone.medium_final}) like '%google%'
           OR lower(${ga_pageviews_clone.source_final}) like '%bing ad extension%'
           OR lower(${ga_pageviews_clone.source_final}) like '%fb click to call%'
           OR (${ga_pageviews_clone.medium_final} in('nativedisplay'))
           OR (${ga_pageviews_clone.medium_final} in('display'))


;;
  }

  dimension: explicit_digital_bool {
    type: yesno
    sql:
           (${ga_pageviews_clone.source_final} in('google', 'bing', 'ask', 'yahoo', 'google.com') and ${ga_pageviews_clone.medium_final} in('cpc', 'paid search'))
           OR lower(${ga_pageviews_clone.medium_final}) like '%google%'
           OR lower(${ga_pageviews_clone.source_final}) like '%bing ad extension%'
           OR lower(${ga_pageviews_clone.source_final}) like '%fb click to call%'
           OR (${ga_pageviews_clone.medium_final} in('nativedisplay'))
           OR (${ga_pageviews_clone.source_final} in('facebook', 'instagram') and ${ga_pageviews_clone.medium_final} in('paidsocial', 'ctr', 'image_carousel', 'static_image'))
           OR  (${ga_pageviews_clone.medium_final} in('display'))
;;
  }
  dimension: channel_name_fixed {
    type: string
    sql:  case when ${name} in('Social Media (Facebook, LinkedIn, Twitter, Instagram)', 'Social Media(Facebook, LinkedIn, Twitter, Instagram)') then 'Social Media (Facebook, LinkedIn, Twitter, Instagram)'
          else ${name} end;;
  }
  measure: count {
    type: count
    drill_fields: [id, name, source_name, type_name]
  }

  dimension: growth_category {
    type: string
    sql: case
   when ${explicit_digital_bool} or (${type_name} is null and ${name} not in('Family or friend', 'Healthcare provider', 'Healthcare Provider', 'Employer')) then 'Direct to Consumer'
   when ${type_name} in ('Provider Group') or ${name} in('Healthcare provider', 'Healthcare Provider') then 'Provider'
   when ${type_name} in('Employer') or ${name} in('Employer') then 'Employer'
   when ${type_name} in('Senior Care', 'Hospice & Palliative Care', 'SNF' )  then 'Senior Care'
   when ${type_name} in('Home Health' )  then 'Home Health'
   when ${type_name} in('Health System' )  then 'Health System'
   when ${name} ='Family or friend' then 'Family or Friends'
   when ${type_name} ='Payer' then 'Payer'
  else concat(coalesce(${type_name}, 'Direct'), ': ', ${name}) end;;
  }

  dimension: direct_consumer_boolean {
    type:  yesno
    sql: (${growth_category} = 'Direct to Consumer') ;;
  }

  dimension: growth_order {
    type: number
    sql: case when ${growth_category} = 'Direct to Consumer' then 1
              when ${growth_category} = 'Employer' then 2
              when ${growth_category} = 'Family or Friends' then 3
              when ${growth_category} = 'Health System' then 4
              when ${growth_category} = 'Home Health' then 5
              when ${growth_category} = 'Provider' then 6
              when ${growth_category} = 'Senior Care' then 7
              when ${growth_category} = 'Payer' then 8
         else null end;;
  }


}
