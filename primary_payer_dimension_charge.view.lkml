view: primary_payer_dimension_charge {
    derived_table: {
      sql: select *
              from
              (SELECT     tf.visit_dim_number,
           tf.payer_dim_id,
           pd.insurance_package_name,
           pd.insurance_package_id,
           pd.insurance_package_type,
           pd.insurance_reporting_category,
           pd.irc_group,
           pd.custom_insurance_grouping
FROM       transaction_facts tf
INNER JOIN primary_payer_dimensions pd
ON         tf.primary_payer_dim_id = pd.id
INNER JOIN visit_facts vf
ON         tf.visit_dim_number = vf.visit_dim_number
WHERE      tf.transaction_type = 'CHARGE'
AND        tf.transaction_reason IS NULL
GROUP BY   tf.visit_dim_number,
           pd.insurance_package_name,
           pd.insurance_package_id,
           pd.insurance_package_type,
           pd.insurance_reporting_category,
           pd.irc_group,
           pd.custom_insurance_grouping) ed_diversion_survey_response
                     ;;
      sql_trigger_value: SELECT CURDATE() ;;
      indexes: ["visit_dim_number", "payer_dim_id"]
    }
    dimension: visit_dim_number {
      label: "EHR Appointment ID"
      type: number
      sql: ${TABLE}.visit_dim_number ;;
    }

    dimension: insurance_package_name {
      type: string
      sql: ${TABLE}.insurance_package_name ;;
    }
  dimension: insurance_package_id {
    type: number
    sql: ${TABLE}.insurance_package_id ;;
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
    type: string
    sql: ${TABLE}.irc_group ;;
  }

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}.custom_insurance_grouping ;;
  }

}
