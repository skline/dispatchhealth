view: channel_dimensions {
  sql_table_name: jasperdb.channel_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: dashboard_channel_item_id {
    hidden: yes
    type: number
    sql: ${TABLE}.dashboard_channel_item_id ;;
  }

  dimension: main_type {
    type: string
    sql: ${TABLE}.main_type ;;
    drill_fields: [
      sub_type,
      organization
    ]
  }

  dimension: sub_type {
    label: "Subtype"
    type: string
    sql: ${TABLE}.sub_type ;;
    drill_fields: [
      organization
    ]
  }

  dimension: organization {
    type: string
    sql: ${TABLE}.organization ;;
  }

  dimension: smfr_visit {
    type: yesno
    sql:  (${main_type} LIKE '%emergency%' OR
          ${organization} LIKE '%smfr%') ;;
  }

  dimension: wmfr_visit {
    type: yesno
    sql:  ${market_dimensions.market_name} = 'West Metro Fire Rescue' AND (
          ${sub_type} LIKE '%911 channel%' OR
          ${sub_type} LIKE '%west metro fire rescue%' OR
          ${organization} LIKE '%wmfr%') ;;
  }

  dimension: organization_label {
    type: string
    order_by_field: org_label_order
    sql: CASE WHEN ${subtotal_over.row_type_description} = '' THEN ${organization}
      ELSE 'Subtotal' END ;;
    html:{% if value == 'Subtotal' %}<b><i><span style="color: black;">Subtotal</span></i></b>{% else %} {{ linked_value }}{% endif %};;
  }

  dimension: org_label_order {
    type: string
    hidden: yes
    #For order by fields, use a similar calculation, but use values that correctly put nulls at min and subtotals at max of sort order positioning
    sql:  CASE WHEN ${organization_label} = ${organization} THEN ${sub_type}||${organization}
      ELSE ${sub_type}||'ZZZZZZZZ' END ;;
  }

  dimension: digital {
    type: yesno
    sql: (${organization} in('google or other search', 'social media (facebook, linkedin, twitter, instagram)', 'social media(facebook, linkedin, twitter, instagram)'))
    OR (${invoca_clone.utm_source} like '%google%' and ${invoca_clone.utm_medium} not in ('organic', 'local', 'referral'))
    OR (${invoca_clone.utm_source} like '%facebook%' and ${invoca_clone.utm_medium} not in ('organic', 'local', 'referral')) ;;
  }

  dimension_group: updated {
    hidden: yes
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
    drill_fields: [id]
  }
}
