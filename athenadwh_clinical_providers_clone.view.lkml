view: athenadwh_clinical_providers_clone {
  sql_table_name: looker_scratch.athenadwh_clinical_providers_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: address1 {
    type: string
    sql: ${TABLE}.address1 ;;
  }

  dimension: address2 {
    type: string
    sql: ${TABLE}.address2 ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: clinical_provider_id {
    type: number
    sql: ${TABLE}.clinical_provider_id ;;
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

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: thr_access_center_provider {
    type: yesno
    sql: ${name} = 'THR ACCESS CENTER' ;;
  }

  dimension: provider_category {
    description: "A flag indicating that the provider is DispatchHealth"
    type: string
    sql:
      CASE
        WHEN ${name} IS NULL THEN 'Provider Unknown'
        WHEN ${name} LIKE '%'|| TRIM(${markets.short_name}) ||' -%' OR ${name}  = 'SOUTH METRO FIRE AND RESCUE' THEN 'Performed On-Scene'
        ELSE 'Performed by Third Party'
    END;;
    drill_fields: [
      athenadwh_lab_imaging_providers.name,
      athenadwh_lab_imaging_results.clinical_order_type
    ]
  }

  dimension: touchworks_flag {
    type: yesno
    sql: ${name} = 'SOUTHWEST MEDICAL TOUCHWORKS' ;;
  }

  dimension: touchworks_name {
    type: string
    sql: ${name} ;;
    html:{% if value == 'SOUTHWEST MEDICAL TOUCHWORKS' %}<b><span style="color: black;">SOUTHWEST MEDICAL TOUCHWORKS</span></b>{% else %} {{ linked_value }}{% endif %};;
  }

  dimension: npi {
    type: string
    sql: ${TABLE}.npi ;;
  }

  dimension: thpg_provider_flag {
    description: "A flag indicating the provider is THPG - Use only with the Athena letter recipient provider view"
    type: yesno
    sql: ${thpg_providers.last_name} IS NOT NULL ;;
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
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

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, name, last_name]
  }

  measure: names_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${name}), ' | ') ;;
  }

  measure: npi_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${npi}), ' | ') ;;
  }

  measure: address_aggregated {
    type: string
    sql: array_agg(distinct ${address_full}) ;;
  }
  dimension: address_full {
    type: string
    sql: concat(${address1},': ',coalesce(${address2}, ''),': ', ${city}, ': ', left(${zip},5)) ;;
  }

  measure: ids_aggregated {
    type: string
    sql: array_agg(distinct ${id}) ;;
  }

}
