view: athena_medication_details {
  sql_table_name: athena.medication ;;
  drill_fields: [medication_id]

  dimension: medication_id {
    primary_key: yes
    type: number
    group_label: "IDs"
    sql: ${TABLE}."medication_id" ;;
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

  dimension: brand_or_generic_indicator {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."brand_or_generic_indicator" ;;
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

  dimension: dea_schedule {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."dea_schedule" ;;
  }

  dimension: fdb_med_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."fdb_med_id" ;;
  }

  dimension: gcn_clinical_forumulation_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."gcn_clinical_forumulation_id" ;;
  }

  dimension: hic1_code {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic1_code" ;;
  }

  dimension: hic1_description {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic1_description" ;;
  }

  dimension: hic2_pharmacological_class {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic2_pharmacological_class" ;;
  }

  dimension: hic3_code {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic3_code" ;;
  }

  dimension: hic3_description {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."hic3_description" ;;
  }

  dimension: hic4_ingredient_base {
    type: string
    hidden: yes
    sql: ${TABLE}."hic4_ingredient_base" ;;
  }

  dimension: med_name_id {
    type: number
    group_label: "IDs"
    sql: ${TABLE}."med_name_id" ;;
  }

  dimension: medication_name {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."medication_name" ;;
  }

  dimension: ndc {
    type: string
    group_label: "Descriptions"
    sql: ${TABLE}."ndc" ;;
  }

  dimension: rxnorm {
    type: string
    hidden: yes
    sql: ${TABLE}."rxnorm" ;;
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

  measure: count {
    type: count
    drill_fields: [medication_id, medication_name]
  }
}
