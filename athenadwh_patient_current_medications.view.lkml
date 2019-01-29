view: athenadwh_patient_current_medications {
    derived_table: {
      sql: SELECT DISTINCT
        apm.patient_id,
        apm.chart_id,
        apm.medication_id,
        apm.medication_name,
        MAX(apm.fill_date) AS fill_date,
        MAX(apm.created_datetime) AS created_datetime,
        apm.created_by
  FROM athenadwh_patient_medication_clone apm
  JOIN (
        SELECT patient_id, chart_id, MAX(DATE(created_datetime)) AS last_visit
        FROM athenadwh_patient_medication_clone
        WHERE medication_type = 'PATIENTMEDICATION'
        GROUP BY 1,2
  ) AS mxv
  ON apm.patient_id = mxv.patient_id AND DATE(apm.created_datetime) = mxv.last_visit
  WHERE apm.medication_type = 'PATIENTMEDICATION'
  GROUP BY 1,2,3,4,7 ;;

  sql_trigger_value: SELECT MAX(created_datetime) FROM athenadwh_patient_medication_clone ;;
  indexes: ["patient_id", "chart_id", "medication_id"]
    }

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.patient_id::varchar, ' ', ${TABLE}.medication_id::varchar) ;;
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

    dimension: deactivated_by {
      type: string
      sql: ${TABLE}.deactivated_by ;;
    }

    dimension_group: deactivation_datetime {
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
      sql: ${TABLE}.deactivation_datetime ;;
    }

    dimension: document_id {
      type: number
      sql: ${TABLE}.document_id ;;
    }

    dimension_group: fill {
      type: time
      timeframes: [
        raw,
        date,
        week,
        month,
        quarter,
        year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.fill_date ;;
    }

    dimension: medication_id {
      type: number
      sql: ${TABLE}.medication_id ;;
    }

    dimension: medication_name {
      type: string
      sql: ${TABLE}.medication_name ;;
    }

    measure: medications_list {
      label: "List of all medications"
      type: string
      sql: string_agg(DISTINCT ${medication_name}, ' | ') ;;
    }

    dimension: patient_id {
      type: number
      sql: ${TABLE}.patient_id ;;
    }


    measure: count_medications {
      type: count_distinct
      sql: ${compound_primary_key} ;;
    }

    # measure: average_medications {
    #   type: average_distinct
    #   sql: ${compound_primary_key} ;;
    # }

    measure: count_distinct_patients {
      type: count_distinct
      sql: ${patient_id} ;;
    }

  }
