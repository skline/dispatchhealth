view: primary_payer_dimensions_clone {
  sql_table_name: looker_scratch.primary_payer_dimensions_clone ;;

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

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}.custom_insurance_grouping ;;
  }

  dimension: medicare_advantage_flag {
    type: yesno
    hidden: yes
    sql: ${custom_insurance_grouping} =  '(MA)MEDICARE ADVANTAGE';;
  }

  dimension: commercial_flag {
    type: yesno
    hidden: yes
    sql: ${custom_insurance_grouping} =  '(CM)COMMERCIAL';;
  }

  dimension: medicare_flag {
    type: yesno
    hidden: yes
    sql: ${custom_insurance_grouping} =  '(MCARE)MEDICARE';;
  }

  dimension: medicaid_flag {
    type: yesno
    hidden: yes
    sql: ${custom_insurance_grouping} =  '(MAID)MEDICAID';;
  }

  dimension: custom_insurance_label {
    type: string
    sql: CASE ${custom_insurance_grouping}
         WHEN '(CB)CORPORATE BILLING' THEN 'Corporate Billing'
        WHEN '(MA)MEDICARE ADVANTAGE' THEN 'Medicare Advantage'
        WHEN '(MAID)MEDICAID' THEN 'Medicaid'
        WHEN '(MMCD)MANAGED MEDICAID' THEN 'Managed Medicaid'
        WHEN '(MCARE)MEDICARE' THEN 'Medicare'
        WHEN '(PSP)PATIENT SELF-PAY' THEN 'Patient Self Pay'
        WHEN 'PATIENT RESPONSIBILITY' THEN 'Patient Self Pay'
        WHEN '(CM)COMMERCIAL' THEN 'Commercial'
        WHEN '(TC)TRICARE' THEN 'Tricare'
        ELSE 'Other'
        END;;
  }

  dimension: payer_type {
    type: string
    description: "Payer type grouped into a concise number of groups"
    sql: CASE
          WHEN ${custom_insurance_grouping} IN ('(CM)COMMERCIAL', '(MA)MEDICARE ADVANTAGE') THEN 'Commercial/Medicare Advantage'
          WHEN ${custom_insurance_grouping} IN ('(MAID)MEDICAID', '(MMCD)MANAGED MEDICAID', '(MCARE)MEDICARE', '(TC)TRICARE') THEN 'Medicare/Medicaid/Tricare'
          WHEN ${custom_insurance_grouping} IN ('(PSP)PATIENT SELF-PAY', 'PATIENT RESPONSIBILITY') THEN 'Patient Self Pay'
          WHEN ${custom_insurance_grouping} = '(CB)CORPORATE BILLING' THEN 'Corporate Billing'
          ELSE 'Other'
          END;;
  }

  dimension: insurance_package_id {
    label: "Insurance Package ID"
    type: string
    sql: ${TABLE}.insurance_package_id ;;
  }

  dimension: insurance_package_name {
    type: string
    sql: ${TABLE}.insurance_package_name ;;
  }

  dimension: insurance_package_name_consolidated {
    type: string
    sql: CASE
          WHEN when UPPER(${insurance_package_name}) LIKE '%HEALTH PLAN OF NEVADA%' THEN 'Health Plan of Nevada'
          WHEN when UPPER(${insurance_package_name}) LIKE '%CULINARY%' THEN 'Culinary'
          ELSE ${insurance_package_name}
        END ;;
  }

  dimension: united_healthcare_category {
    type: string
    sql: case when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - SIERRA HEALTH & LIFE - SENIOR DIMENSION (MEDICARE REPLACEMENT HMO)') then 'HPN Medicare Advantage'
              when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - SMARTCHOICE (MEDICAID HMO)') then 'HPN Managed Medicaid'
              when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - UNITED HEALTHCARE CHOICE PLUS (POS)', 'SIERRA HEALTH LIFE') then 'HPN Commercial'
              when ${insurance_package_name} in('UHC WEST - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT HMO)', 'UHC - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT PPO) ') then 'UHC Medicare Advantage'
              when ${insurance_package_name} in('UMR', 'UNITED HEALTHCARE', 'UNITED HEALTHCARE (PPO)') then 'UHC Commercial'
              else null end;;
  }

  dimension: uhc_reporting_category {
    description: "Consolidated insurance package names for Nevada UHC payer reporting"
    type: string
    sql: case when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - SIERRA HEALTH & LIFE - SENIOR DIMENSION (MEDICARE REPLACEMENT HMO)',
                                                'UHC - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT PPO)',
                                                'UHC WEST - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT HMO)')
          then 'HPN Medicare Advantage'
              when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - SMARTCHOICE (MEDICAID HMO)')
          then 'HPN Managed Medicaid'
              when ${insurance_package_name} in('HEALTH PLAN OF NEVADA - UNITED HEALTHCARE CHOICE PLUS (POS)',
                                                'SIERRA HEALTH LIFE',
                                                'UMR',
                                                'UNITED HEALTHCARE',
                                                'UNITED HEALTHCARE (PPO)')
          then 'HPN Commercial'
              else null end;;
  }

  dimension: insurance_package_type {
    type: string
    sql: ${TABLE}.insurance_package_type ;;
  }

  dimension: insurance_reporting_category {
    type: string
    sql: ${TABLE}.insurance_reporting_category ;;
  }

  dimension: irc_group {
    label: "IRC Group"
    type: string
    sql: ${TABLE}.irc_group ;;
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
    drill_fields: [id, insurance_package_name]
  }
}
