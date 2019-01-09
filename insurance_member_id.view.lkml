view: insurance_member_id {
  derived_table: {
    sql:
SELECT
  ins.id,
  ins.patient_id,
  member_id,
  group_number,
  package_id,
  eligibility_message
  FROM public.insurances ins
  INNER JOIN (
        SELECT id,
        patient_id,
        ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY id DESC) AS row_num
        FROM public.insurances
  ) AS prim
    ON ins.id = prim.id AND prim.row_num = 1
  WHERE ins.priority = '1'
  ORDER BY patient_id ;;

  sql_trigger_value: SELECT MAX(created_at) FROM care_request_statuses ;;
  indexes: ["id"]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: patient_id {
    type: number
    sql: ${TABLE}.patient_id ;;
  }

  dimension: member_id {
    type: string
    sql: ${TABLE}.member_id ;;
  }

  dimension: group_number {
    type: string
    sql: ${TABLE}.group_number ;;
  }

}
