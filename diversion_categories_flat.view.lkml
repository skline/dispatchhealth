view: diversion_categories_flat {
    sql_table_name: looker_scratch.diversion_categories_by_care_request ;;

dimension: care_request_id {
  primary_key: yes
  type: number
  sql: ${TABLE}.care_request_id ;;
}
  dimension: diagnosis_code1 {
    type: string
    sql: ${TABLE}.diagnosis_code1 ;;
  }
  dimension: diagnosis_code2 {
    type: string
    sql: ${TABLE}.diagnosis_code2 ;;
  }
  dimension: diagnosis_code3 {
    type: string
    sql: ${TABLE}.diagnosis_code3;;
  }
  dimension: diagnosis_only {
    type: number
    sql: ${TABLE}.diagnosis_only ;;
  }
  dimension: survey_yes_to_er {
    type: number
    sql: ${TABLE}.survey_yes_to_er ;;
  }
  dimension: diversion_911 {
    type: number
    sql: ${TABLE}.diversion_911 ;;
  }
  dimension: pos_snf {
    type: number
    sql: ${TABLE}.pos_snf ;;
  }
  dimension: pos_al {
    type: number
    sql: ${TABLE}.pos_al ;;
  }
  dimension: referral {
    type: number
    sql: ${TABLE}.referral ;;
  }
  dimension: after_hours {
    type: number
    sql: ${TABLE}.after_hours ;;
  }
  dimension: abnormal_vitals {
    type: number
    sql: ${TABLE}.abnormal_vitals ;;
  }
  dimension: confusion {
    type: number
    sql: ${TABLE}.confusion ;;
  }
  dimension: wheelchair_hb {
    type: number
    sql: ${TABLE}.wheelchair_hb ;;
  }
  dimension: ekg {
    type: number
    sql: ${TABLE}.ekg ;;
  }
  dimension: nebulizer {
    type: number
    sql: ${TABLE}.nebulizer ;;
  }
  dimension: iv_fluids {
    type: number
    sql: ${TABLE}.iv_fluids ;;
  }
  dimension: blood_tests {
    type: number
    sql: ${TABLE}.blood_tests ;;
  }
  dimension: catheter_placement {
    type: number
    sql: ${TABLE}.catheter_placement ;;
  }
  dimension: laceration_repair {
    type: number
    sql: ${TABLE}.laceration_repair ;;
  }
  dimension: epistaxis {
    type: number
    sql: ${TABLE}.epistaxis ;;
  }
  dimension: hernia_rp_reduction {
    type: number
    sql: ${TABLE}.hernia_rp_reduction ;;
  }
  dimension: joint_reduction {
    type: number
    sql: ${TABLE}.joint_reduction ;;
  }
  dimension: gastronomy_tube {
    type: number
    sql: ${TABLE}.gastronomy_tube ;;
  }
  dimension: abscess_drain {
    type: number
    sql: ${TABLE}.abscess_drain ;;
  }
  dimension: dc22 {
    type: number
    sql: ${TABLE}.dc22 ;;
  }
  dimension: dc23 {
    type: number
    sql: ${TABLE}.dc23 ;;
  }
  dimension: dc24 {
    type: number
    sql: ${TABLE}.dc24 ;;
  }
  dimension: dc25 {
    type: number
    sql: ${TABLE}.dc25 ;;
  }
  dimension: dc26 {
    type: number
    sql: ${TABLE}.dc26 ;;
  }
  dimension: dc27 {
    type: number
    sql: ${TABLE}.dc27 ;;
  }
  dimension: dc28 {
    type: number
    sql: ${TABLE}.dc28 ;;
  }
  dimension: dc29 {
    type: number
    sql: ${TABLE}.dc29 ;;
  }
  dimension: dc30 {
    type: number
    sql: ${TABLE}.dc30 ;;
  }
  dimension: dc31 {
    type: number
    sql: ${TABLE}.dc31 ;;
  }
  dimension: dc32 {
    type: number
    sql: ${TABLE}.dc32 ;;
  }
  dimension: dc33 {
    type: number
    sql: ${TABLE}.dc33 ;;
  }
  dimension: dc34 {
    type: number
    sql: ${TABLE}.dc34 ;;
  }
  dimension: dc35 {
    type: number
    sql: ${TABLE}.dc35 ;;
  }
  dimension: dc36 {
    type: number
    sql: ${TABLE}.dc36 ;;
  }
  dimension: dc37 {
    type: number
    sql: ${TABLE}.dc37 ;;
  }
  dimension: dc38 {
    type: number
    sql: ${TABLE}.dc38 ;;
  }
  dimension: dc39 {
    type: number
    sql: ${TABLE}.dc39 ;;
  }
  dimension: dc40 {
    type: number
    sql: ${TABLE}.dc40 ;;
  }
  dimension: dc41 {
    type: number
    sql: ${TABLE}.dc41 ;;
  }




}
