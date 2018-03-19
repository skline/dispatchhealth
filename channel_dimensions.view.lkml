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
  }

  dimension: sub_type {
    label: "Subtype"
    type: string
    sql: ${TABLE}.sub_type ;;
  }

  dimension: organization {
    type: string
    sql: ${TABLE}.organization ;;
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

  ## From Looker website on the creation of subtotals and underlying sort functionality
  # dimension: product_name {
  #   order_by_field: product_order
  #   # For subtotal rows: show 'SUBTOTAL'.  For nulls, show '∅' (supports intuitive sorting).  Otherwise use raw base table field's data. Note, concatenation with '${row_type_checker}' is used to concisely force subtotal rows to evaluate to null, which is then converted to 'SUBTOTAL'
  #   sql: coalesce(cast(coalesce(cast(${products.name} as varchar),'∅')||${row_type_checker} as varchar),'SUBTOTAL');;
  # }
  # dimension: product_order {
  #   hidden: yes
  #   #For order by fields, use a similar calculation, but use values that correctly put nulls at min and subtotals at max of sort order positioning
  #   sql: coalesce(cast(coalesce(cast(${products.name} as varchar),'          ')||${row_type_checker} as varchar),'ZZZZZZZZZZ');;
  # }



  dimension: digital {
    type: yesno
    sql: (${organization} in('google or other search', 'social media (facebook, linkedin, twitter, instagram)', 'social media(facebook, linkedin, twitter, instagram)'))
    OR (${invoca_clone.utm_source} like '%google%' and ${invoca_clone.utm_medium} not in ('organic', 'local', 'referral'))
    OR (${invoca_clone.utm_source} like '%facebook%' and ${invoca_clone.utm_medium} not in ('organic', 'local', 'referral')) ;;
  }

  dimension: centura_organization {
    type: string
    sql: CASE
          WHEN ${centura_mssp_eligible.group_member_id} IS NOT NULL AND
          ${organization} NOT LIKE '%centura%' THEN 'centura health - other channel'
          WHEN (${organization} = 'centura connect' OR ${organization} = 'centura health mssp aco') THEN 'centura health'
          WHEN (${organization} = 'centura health - centura health at home' OR ${organization} = 'centura health at home') THEN 'centura health at home'
          ELSE ${organization}
          END;;
  }

  dimension: bonsecours_organization {
    type: string
    sql: CASE
          WHEN ${bonsecours_mssp_eligible.group_member_id} IS NOT NULL AND
          ${organization} NOT LIKE '%bon secours%' THEN 'bon secours - other channel'
          WHEN ${organization} LIKE '%bon secours%' THEN 'bon secours'
          ELSE ${organization}
        END;;
  }

  dimension: ccha_organization {
    type: string
    sql: CASE
          WHEN ${ccha_eligible.group_member_id} IS NOT NULL AND
          ${organization} NOT LIKE '%ccha%' THEN 'ccha - other channel'
          WHEN ${organization} LIKE '%ccha%' THEN 'ccha'
          ELSE ${organization}
        END;;
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
