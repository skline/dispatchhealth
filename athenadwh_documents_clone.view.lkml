view: athenadwh_documents_clone {
  sql_table_name: looker_scratch.athenadwh_documents_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: clinical_encounter_id {
    type: number
    sql: ${TABLE}.clinical_encounter_id ;;
  }

  dimension: clinical_order_genus {
    type: string
    sql: ${TABLE}.clinical_order_genus ;;
  }

  dimension: clinical_order_type {
    type: string
    sql: ${TABLE}.clinical_order_type ;;
  }

  dimension: rapid_strep_test {
    type: yesno
    description: "A flag indicating a rapid strep test"
    sql: ${clinical_order_type} LIKE '%RAPID STREP GROUP A%' ;;
  }

  dimension: referral_type {
    type: string
    sql: CASE
          WHEN ${clinical_order_type} LIKE '%REFERRAL%' THEN INITCAP(SUBSTRING(${clinical_order_type}, 1, POSITION('REFERRAL' in ${clinical_order_type})-1))
          ELSE INITCAP(${clinical_order_type})
        END
          ;;
    drill_fields: [
      athenadwh_referral_providers.name,
      athenadwh_referral_providers.provider_category
    ]
  }

  measure: order_type_concat {
    label: "Description Of Items Ordered"
    type: string
    sql: string_agg(DISTINCT ${clinical_order_type}, ' | ') ;;
  }

  measure: genus_type_concat {
    label: "Genus Of Items Ordered"
    type: string
    sql: string_agg(DISTINCT ${clinical_order_genus}, ' | ') ;;
  }

  dimension: prescriptions_flag {
    type: yesno
    sql: ${document_class} = 'PRESCRIPTION' ;;
  }

  dimension: medicine_administered_onscene {
    type: yesno
    description: "A flag indicating that medicine was administered on-scene"
    sql: ${document_class} = 'PRESCRIPTION' AND ${clinical_provider_id} IS NULL ;;
  }

  dimension: labs_flag {
    type: yesno
    sql: ${document_class} = 'LABRESULT' ;;
  }

  dimension: imaging_flag {
    type: yesno
    sql: ${document_class} = 'IMAGINGRESULT' ;;
  }

  dimension: dme_flag {
    type: yesno
    sql: ${document_class} = 'DME' ;;
  }

  dimension: orders_flag {
    type: yesno
    sql: ${document_class} = 'ORDER' ;;
  }

  dimension: provider_referrals_flag {
    type: yesno
    sql: ${clinical_order_type} LIKE '%REFERRAL%' AND ${clinical_order_type} NOT LIKE 'HOME HEALTH%' ;;
  }

  dimension: home_health_referrals_flag {
    type: yesno
    sql: ${clinical_order_type} LIKE 'HOME HEALTH%REFERRAL' ;;
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

  dimension: created_datetime {
    type: string
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: deleted_datetime {
    type: string
    sql: ${TABLE}.deleted_datetime ;;
  }

  dimension: document_class {
    type: string
    sql: ${TABLE}.document_class ;;
  }

  dimension: document_id {
    type: number
    sql: ${TABLE}.document_id ;;
  }

  dimension: document_subclass {
    type: string
    sql: ${TABLE}.document_subclass ;;
  }

  dimension: feed_dates {
    type: string
    sql: ${TABLE}.feed_dates ;;
  }

  dimension: route {
    type: string
    sql: ${TABLE}.route ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
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
    drill_fields: [id]
  }

  measure: count_documents {
    type: count_distinct
    sql: ${document_id} ;;
  }

  measure: count_encounters {
    type: count_distinct
    sql: ${clinical_encounter_id} ;;
  }

}
