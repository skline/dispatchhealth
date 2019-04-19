view: primary_payer_dimensions {
  sql_table_name: jasperdb.primary_payer_dimensions ;;

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
  dimension: insurance_package_id {
    label: "Insurance Package ID"
    type: string
    sql: ${TABLE}.insurance_package_id ;;
  }

  dimension: insurance_package_name {
    type: string
    sql: ${TABLE}.insurance_package_name ;;
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
                                                'UHC WEST - AARP - MEDICARE SOLUTIONS - MEDICARE COMPLETE (MEDICARE REPLACEMENT HMO)',
                                                'OPTUMCARE NETWORK OF NEVADA - UNITED HEALTHCARE (MEDICARE REPLACEMENT/ADVANTAGE - HMO)')
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
