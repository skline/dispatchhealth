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
    description: "Diagnosis Only"
    type: number
    sql: ${TABLE}.diagnosis_only ;;
  }
  dimension: survey_yes_to_er {
    description: "Survey Response YES to ER"
    type: number
    sql: ${TABLE}.survey_yes_to_er ;;
  }
  dimension: diversion_911 {
    description: "911 Diversion Program"
    type: number
    sql: ${TABLE}.diversion_911 ;;
  }
  dimension: pos_snf {
    description: "POS SNF"
    type: number
    sql: ${TABLE}.pos_snf ;;
  }
  dimension: pos_al {
    description: "POS Assisted Living"
    type: number
    sql: ${TABLE}.pos_al ;;
  }
  dimension: referral {
    description: "Referred from Home Health, PCP or Care Mgmt"
    type: number
    sql: ${TABLE}.referral ;;
  }
  dimension: after_hours {
    description: "Weekends or After 3 PM"
    type: number
    sql: ${TABLE}.after_hours ;;
  }
  dimension: abnormal_vitals {
    description: "Abnormal Vitals (O2 sat < 90%, HR > 100, SBP < 90 for adults)"
    type: number
    sql: ${TABLE}.abnormal_vitals ;;
  }
  dimension: confusion {
    description: "Additional Dx of Confusion or Altered Awareness"
    type: number
    sql: ${TABLE}.confusion ;;
  }
  dimension: wheelchair_hb {
    description: "Wheelchair or Homebound"
    type: number
    sql: ${TABLE}.wheelchair_hb ;;
  }
  dimension: ekg {
    description: "EKG Performed"
    type: number
    sql: ${TABLE}.ekg ;;
  }
  dimension: nebulizer {
    description: "Nebulizer Treatment"
    type: number
    sql: ${TABLE}.nebulizer ;;
  }
  dimension: iv_fluids {
    description: "IV/Fluids Administered"
    type: number
    sql: ${TABLE}.iv_fluids ;;
  }
  dimension: blood_tests {
    description: "Blood Tests Performed"
    type: number
    sql: ${TABLE}.blood_tests ;;
  }
  dimension: catheter_placement {
    description: "Catheter Adjustment or Placement"
    type: number
    sql: ${TABLE}.catheter_placement ;;
  }
  dimension: laceration_repair {
    description: "Laceration Repair"
    type: number
    sql: ${TABLE}.laceration_repair ;;
  }
  dimension: epistaxis {
    description: "Epistaxis Tx"
    type: number
    sql: ${TABLE}.epistaxis ;;
  }
  dimension: hernia_rp_reduction {
    description: "Rectal Prolapse Reduction or Hernia Reduction"
    type: number
    sql: ${TABLE}.hernia_rp_reduction ;;
  }
  dimension: joint_reduction {
    description: "Nursemaids elbow reduction or other joint reduction"
    type: number
    sql: ${TABLE}.joint_reduction ;;
  }
  dimension: gastronomy_tube {
    description: "Gastrostomy Tube replacement or repair"
    type: number
    sql: ${TABLE}.gastronomy_tube ;;
  }
  dimension: abscess_drain {
    description: "I&D of Abscess"
    type: number
    sql: ${TABLE}.abscess_drain ;;
  }
  dimension: dc22 {
    description: "POS SNF AND (abnormal vital signs  OR altered mental status)"
    type: number
    sql: ${TABLE}.dc22 ;;
  }
  dimension: dc23 {
    description: "POS SNF AND any procedures"
    type: number
    sql: ${TABLE}.dc23 ;;
  }
  dimension: dc24 {
    description: "POS SNF AND referral"
    type: number
    sql: ${TABLE}.dc24 ;;
  }
  dimension: dc25 {
    description: "POS SNF AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql: ${TABLE}.dc25 ;;
  }
  dimension: dc26 {
    description: "POS SNF AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql: ${TABLE}.dc26 ;;
  }
  dimension: dc27 {
    description: "POS AL AND (abnormal vital signs OR altered mental status)"
    type: number
    sql: ${TABLE}.dc27 ;;
  }
  dimension: dc28 {
    description: "POS AL AND procedures"
    type: number
    sql: ${TABLE}.dc28 ;;
  }
  dimension: dc29 {
    description: "POS AL AND referral"
    type: number
    sql: ${TABLE}.dc29 ;;
  }
  dimension: dc30 {
    description: "POS AL AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql: ${TABLE}.dc30 ;;
  }
  dimension: dc31 {
    description: "POS AL AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql: ${TABLE}.dc31 ;;
  }
  dimension: dc32 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status)"
    type: number
    sql: ${TABLE}.dc32 ;;
  }
  dimension: dc33 {
    description: "POS HOME AND any procedures"
    type: number
    sql: ${TABLE}.dc33 ;;
  }
  dimension: dc34 {
    description: "POS HOME AND referral"
    type: number
    sql: ${TABLE}.dc34 ;;
  }
  dimension: dc35 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql: ${TABLE}.dc35 ;;
  }
  dimension: dc36 {
    description: "POS HOME AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql: ${TABLE}.dc36 ;;
  }
  dimension: dc37 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status)"
    type: number
    sql: ${TABLE}.dc37 ;;
  }
  dimension: dc38 {
    description: "POS HOME AND wheelchair/homebound AND any procedures"
    type: number
    sql: ${TABLE}.dc38 ;;
  }
  dimension: dc39 {
    description: "POS HOME AND wheelchair/homebound AND referral"
    type: number
    sql: ${TABLE}.dc39 ;;
  }
  dimension: dc40 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status) AND any procedures"
    type: number
    sql: ${TABLE}.dc40 ;;
  }
  dimension: dc41 {
    description: "POS HOME AND wheelchair/homebound AND (abnormal vital signs OR altered mental status OR any procedures OR referral) AND afterhours/weekend/holiday"
    type: number
    sql: ${TABLE}.dc41 ;;
  }




}
