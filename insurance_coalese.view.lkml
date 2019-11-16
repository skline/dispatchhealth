view: insurance_coalese {
    derived_table: {
      sql:
      SELECT
    cr.id as care_request_id,
    COALESCE(athena.insurance_package_id, sri.package_id) package_id_coalese,
    athena.insurance_package_id as athena_package_id,
    sri.package_id as self_report_package_id
    FROM public.care_requests cr
    JOIN public.patients pt
    ON pt.id=cr.patient_id
    LEFT JOIN (
        SELECT
            cr2.id AS care_request_id,
            package_id,
            ROW_NUMBER() OVER(PARTITION BY cr2.id ORDER BY ins.created_at desc) as rn
        FROM public.care_requests cr2
        JOIN public.patients pt
        ON pt.id=cr2.patient_id
        JOIN public.insurances ins
        ON cr2.patient_id = ins.patient_id AND ins.priority = '1'
        AND ins.patient_id IS NOT NULL
        AND cr2.created_at + interval '1' day >= ins.created_at
        AND ins.package_id IS NOT NULL
        AND TRIM(ins.package_id)!='') AS sri
      ON sri.care_request_id=cr.id AND sri.rn=1
    LEFT JOIN (
        SELECT
            cr.id AS care_request_id,
            ppdc.insurance_package_id,
            ROW_NUMBER() OVER (PARTITION BY cr.id
            ORDER BY (CASE WHEN ppdc.custom_insurance_grouping = '(CB)CORPORATE BILLING' THEN 0 ELSE 1 END) DESC) AS rn
            FROM public.care_requests cr
            LEFT JOIN looker_scratch.visit_dimensions_clone vdc
                ON cr.id = vdc.care_request_id
            LEFT JOIN looker_scratch.transaction_facts_clone tfc
                ON tfc.visit_dim_number = vdc.visit_number
                AND tfc.voided_date IS NULL
            LEFT JOIN looker_scratch.primary_payer_dimensions_clone ppdc
                ON tfc.primary_payer_dim_id = ppdc.id) athena
        ON athena.care_request_id = sri.care_request_id AND athena.rn = 1
        GROUP BY 1,2,3,4;;

      sql_trigger_value:  select sum(timevalue)
from
(select count(*) as timevalue
from public.care_requests
union all
select count(*) as timevalue
from looker_scratch.transaction_facts_clone
)lq ;;
      indexes: ["care_request_id", "package_id_coalese"]
    }

    dimension: care_request_id {
      type: number
      sql: ${TABLE}.care_request_id ;;
    }

  dimension: package_id_coalese {
    type: number
    sql: ${TABLE}.package_id_coalese ;;
  }
}
