view: athenadwh_medication_clone {
  sql_table_name: looker_scratch.athenadwh_medication_clone ;;

  dimension: dea_schedule {
    type: string
    sql: ${TABLE}.dea_schedule ;;
  }

  dimension: fdb_med_id {
    type: number
    sql: ${TABLE}.fdb_med_id ;;
  }

  dimension: gcn_clinical_forumulation_id {
    type: number
    sql: ${TABLE}.gcn_clinical_forumulation_id ;;
  }

  dimension: hic1_code {
    type: string
    sql: ${TABLE}.hic1_code ;;
  }

  dimension: hic1_description {
    type: string
    sql: ${TABLE}.hic1_description ;;
  }

  dimension: hic2_pharmacological_class {
    type: string
    sql: ${TABLE}.hic2_pharmacological_class ;;
  }

  dimension: hic3_code {
    type: string
    sql: ${TABLE}.hic3_code ;;
  }

  dimension: hic3_description {
    type: string
    sql: ${TABLE}.hic3_description ;;
  }

  dimension: hic4_ingredient_base {
    type: string
    sql: ${TABLE}.hic4_ingredient_base ;;
  }

  dimension: med_name_id {
    type: number
    sql: ${TABLE}.med_name_id ;;
  }

  dimension: medication_id {
    type: number
    sql: ${TABLE}.medication_id ;;
  }

  dimension: medication_name {
    type: string
    sql: ${TABLE}.medication_name ;;
  }

  dimension: ndc {
    type: string
    sql: ${TABLE}.ndc ;;
  }

  dimension: rxnorm {
    type: string
    sql: ${TABLE}.rxnorm ;;
  }

  measure: count {
    type: count
    drill_fields: [medication_name]
  }
}
