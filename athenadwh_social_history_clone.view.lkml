view: athenadwh_social_history_clone {
  sql_table_name: looker_scratch.athenadwh_social_history_clone ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: answer {
    type: string
    sql: ${TABLE}.answer ;;
  }

  dimension: chart_id {
    type: number
    sql: ${TABLE}.chart_id ;;
  }

  dimension: created_by {
    type: string
    sql: ${TABLE}.created_by ;;
  }

  dimension_group: created_datetime {
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
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: deleted_by {
    type: string
    sql: ${TABLE}.deleted_by ;;
  }

  dimension_group: deleted_datetime {
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
    sql: ${TABLE}.deleted_datetime ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: question {
    type: string
    sql: ${TABLE}.question ;;
  }

  dimension: social_history_key {
    type: string
    sql: ${TABLE}.social_history_key ;;
  }

  dimension: social_history_category {
    type: string
    sql: CASE
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.121' THEN 'Provided Alcohol Education'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.141' THEN 'Transportation'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.141.NOTES' THEN 'Transportation Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.142' THEN 'Nutrition Overall'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.143' THEN 'Nutrition'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.143.NOTES' THEN 'Nutrition Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.144' THEN 'Activities of Daily Living'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.144.NOTES' THEN 'Activities of Daily Living Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.145' THEN 'Fall Risk - Unsteady'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.145.NOTES' THEN 'Fall Risk - Unsteady Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.146' THEN 'Fall Risk - Worry'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.146.NOTES' THEN 'Fall Risk - Worry Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.147' THEN 'Fall Risk - Provider Opinion'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.147.NOTES' THEN 'Fall Risk - Provider Opinion Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.148' THEN 'Social Support'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.148.NOTES' THEN 'Social Support Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.149' THEN 'Social Support'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.149.NOTES' THEN 'Social Support Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.150' THEN 'Financial'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.150.NOTES' THEN 'Financial Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.91' THEN 'Home Cleanliness Review'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.92' THEN 'Trip/Fall Hazards'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.93' THEN 'Overall Nutritional Status'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.94' THEN 'Local Care Assistance Available'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.95' THEN 'Professional Services That May Benefit'
          WHEN ${social_history_key} = 'SOCIALHISTORY.LOCAL.97' THEN 'Medication Reconciliation'
          WHEN ${social_history_key} = 'REVIEWED.SOCIALHISTORY' THEN 'Review Date'
          WHEN ${social_history_key} = 'SOCIALHISTORY.ADVANCEDIRECTIVE' THEN 'Advance Directive'
          WHEN ${social_history_key} = 'SOCIALHISTORY.ADVANCEDIRECTIVE.NOTES' THEN 'Advance Directive Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.ALCOHOL' THEN 'Alcohol Intake'
          WHEN ${social_history_key} = 'SOCIALHISTORY.CODESTATUS' THEN 'Code Status'
          WHEN ${social_history_key} = 'SOCIALHISTORY.CODESTATUS.NOTES' THEN 'Code Status Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.DRUGSABUSED' THEN 'Drugs Abused'
          WHEN ${social_history_key} = 'SOCIALHISTORY.DRUGSABUSED.NOTES' THEN 'Drugs Abused Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.FOURORMOREDRINKS' THEN 'Heavy Drinking - Num Days Past Year'
          WHEN ${social_history_key} = 'SOCIALHISTORY.FOURORMOREDRINKS.NOTES' THEN 'Heavy Drinking Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.FREETEXT' THEN 'Provider Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.MARITALSTATUS' THEN 'Marital Status'
          WHEN ${social_history_key} = 'SOCIALHISTORY.SMOKING' THEN 'Smoking Amount'
          WHEN ${social_history_key} = 'SOCIALHISTORY.SMOKING.NOTES' THEN 'Smoking Amount Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.SMOKINGSTATUS' THEN 'Smoking Status'
          WHEN ${social_history_key} = 'SOCIALHISTORY.SMOKINGSTATUS.NOTES' THEN 'Smoking Status Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.TOBACCOCESSATIONCOUNSELINGPROVIDED' THEN 'Tobacco Cessation Counseling Provided'
          WHEN ${social_history_key} = 'SOCIALHISTORY.TOBACCOCESSATIONCOUNSELINGPROVIDED.NOTES' THEN 'Tobacco Cessation Counseling Notes'
          WHEN ${social_history_key} = 'SOCIALHISTORY.TOBACCOUSE' THEN 'Tobacco - Years of Use'
          WHEN ${social_history_key} = 'SOCIALHISTORY.TOBACCOUSE.NOTES' THEN 'Tobacco - Years of Use Notes'
          ELSE NULL
         END ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
