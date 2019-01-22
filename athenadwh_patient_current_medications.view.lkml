view: athenadwh_patient_current_medications {
    derived_table: {
      sql: SELECT
        apm.patient_medication_id,
        apm.medication_type,
        apm.patient_id,
        apm.chart_id,
        apm.document_id,
        apm.medication_id,
        apm.sig,
        apm.medication_name,
        apm.dosage_form,
        apm.dosage_action,
        apm.dosage_strength,
        apm.dosage_strength_units,
        apm.dosage_quantity,
        apm.dosage_route,
        apm.frequency,
        apm.prescription_fill_quantity,
        apm.number_of_refills_prescribed,
        apm.fill_date,
        apm.pharmacy_name,
        apm.med_administered_datetime,
        apm.created_datetime,
        apm.created_by,
        apm.deactivation_datetime,
        apm.deactivated_by

  FROM athenadwh_patient_medication_clone apm
  JOIN (
        SELECT patient_id, chart_id, MAX(DATE(created_datetime)) AS last_visit
        FROM athenadwh_patient_medication_clone
        WHERE medication_type = 'PATIENTMEDICATION'
        GROUP BY 1,2
  ) AS mxv
  ON apm.patient_id = mxv.patient_id AND DATE(apm.created_datetime) = mxv.last_visit
  WHERE apm.medication_type = 'PATIENTMEDICATION' ;;

  sql_trigger_value: SELECT MAX(created_datetime) FROM athenadwh_patient_medication_clone ;;
  indexes: ["patient_id", "chart_id"]
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

    dimension: dosage_action {
      type: string
      sql: ${TABLE}.dosage_action ;;
    }

    dimension: dosage_form {
      type: string
      sql: ${TABLE}.dosage_form ;;
    }

    dimension: dosage_quantity {
      type: number
      sql: ${TABLE}.dosage_quantity ;;
    }

    dimension: dosage_route {
      type: string
      sql: ${TABLE}.dosage_route ;;
    }

    dimension: dosage_strength {
      type: string
      sql: ${TABLE}.dosage_strength ;;
    }

    dimension: dosage_strength_units {
      type: string
      sql: ${TABLE}.dosage_strength_units ;;
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

    dimension: frequency {
      type: string
      sql: ${TABLE}.frequency ;;
    }

    dimension_group: med_administered_datetime {
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
      sql: ${TABLE}.med_administered_datetime ;;
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

    dimension: medication_type {
      type: string
      sql: ${TABLE}.medication_type ;;
    }

    dimension: number_of_refills_prescribed {
      type: number
      sql: ${TABLE}.number_of_refills_prescribed ;;
    }

    dimension: patient_id {
      type: number
      sql: ${TABLE}.patient_id ;;
    }

    dimension: patient_medication_id {
      type: number
      sql: ${TABLE}.patient_medication_id ;;
      primary_key: yes
    }

    dimension: pharmacy_name {
      type: string
      sql: ${TABLE}.pharmacy_name ;;
    }

    dimension: prescription_fill_quantity {
      type: number
      sql: ${TABLE}.prescription_fill_quantity ;;
    }

    dimension: sig {
      type: string
      sql: ${TABLE}.sig ;;
    }

    measure: count {
      type: count
      drill_fields: [medication_name, pharmacy_name]
    }

    measure: count_medications {
      type: count
      sql: ${patient_medication_id} ;;
    }

    measure: count_distinct_patients {
      type: count_distinct
      sql: ${patient_id} ;;
    }

  }
