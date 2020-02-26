view: insurance_plans {
  sql_table_name: public.insurance_plans ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: active {
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension_group: created {
    type: time
    hidden: no
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

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}.note ;;
  }

  dimension: note_prioritized {
    type: string
    description: "The prioritized note displayed in dashboard: 1. service line, 2. market, 3. insurance plans"
    sql: CASE
          WHEN trim(${insurance_plan_service_lines.note}) <>'' AND ${insurance_plan_service_lines.note} IS NOT NULL
          THEN ${insurance_plan_service_lines.note}
          WHEN trim(${market_insurance_plans.note}) <> '' AND ${market_insurance_plans.note} IS NOT NULL
          THEN ${market_insurance_plans.note}
          WHEN trim(${note}) <> '' AND ${note} IS NOT NULL THEN ${note}
          ELSE NULL
        END ;;
  }

  measure: notes_prioritized {
    type: string
    description: "The prioritized notes displayed in dashboard: 1. service line, 2. market, 3. insurance plans"
    sql: array_to_string(array_agg(DISTINCT ${note_prioritized}),' | ') ;;
  }

  dimension: package_id {
    type: string
    description: "Athena Package ID"
    sql: ${TABLE}.package_id ;;
  }

  dimension: insurance_classification_id {
    type: string
    hidden: no
    sql: ${TABLE}.insurance_classification_id ;;
  }

  dimension: plan_type {
    type: number
    sql: ${TABLE}.plan_type ;;
  }

  dimension: primary {
    type: yesno
    sql: ${TABLE}.primary ;;
  }

  dimension: secondary {
    type: yesno
    sql: ${TABLE}.secondary ;;
  }

  dimension: state_id {
    type: number
    sql: ${TABLE}.state_id ;;
  }

  dimension: tertiary {
    type: yesno
    sql: ${TABLE}.tertiary ;;
  }

  dimension: er_diversion {
    type: number
    description: "The cost savings associated with ER diversions for the insurance package"
    sql: ${TABLE}.er_diversion ;;
  }

  dimension: nine_one_one_diversion {
    type: number
    description: "The cost savings associated with 911 diversions for the insurance package"
    sql: ${TABLE}.nine_one_one_diversion ;;
  }

  dimension: observation_diversion {
    type: number
    description: "The cost savings associated with observation diversions for the insurance package"
    sql: ${TABLE}.observation_diversion ;;
  }

  dimension: hospitalization_diversion {
    type: number
    description: "The cost savings associated with hospitalization diversions for the insurance package"
    sql: ${TABLE}.hospitalization_diversion ;;
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
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
