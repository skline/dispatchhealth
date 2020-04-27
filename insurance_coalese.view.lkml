view: insurance_coalese {
    derived_table: {
      sql:
    SELECT
    cr.id as care_request_id,
    COALESCE(athena.insurance_package_id, sri.package_id) package_id_coalese,
    athena.insurance_package_id as athena_package_id,
    sri.package_id as self_report_package_id,
    sri.member_id,
    cig.custom_insurance_grouping
    FROM public.care_requests cr
    JOIN public.patients pt
    ON pt.id=cr.patient_id
    LEFT JOIN (
        SELECT
            cr2.id AS care_request_id,
            cr2.patient_id,
            package_id,
            member_id,
            crs.created_date,
            cro.on_scene_date,
            ROW_NUMBER() OVER(PARTITION BY cr2.id ORDER BY ins.created_at desc) as rn
    FROM public.care_requests cr2
    JOIN (
        SELECT
            care_request_id,
            MAX(started_at) AS created_date
        FROM public.care_request_statuses
        WHERE name = 'requested'
        GROUP BY 1) crs
        ON cr2.id = crs.care_request_id
    LEFT JOIN (
        SELECT
            care_request_id,
            MAX(started_at) AS on_scene_date
        FROM public.care_request_statuses
        WHERE name = 'on_scene'
        GROUP BY 1) cro
        ON cr2.id = cro.care_request_id
    LEFT JOIN public.patients pt
        ON pt.id=cr2.patient_id
    LEFT JOIN public.insurances ins
    ON cr2.patient_id = ins.patient_id AND ins.priority = '1'
        AND ins.patient_id IS NOT NULL
        AND COALESCE(ins.start_date,crs.created_date) <= crs.created_date AND
        COALESCE(ins.end_date,crs.created_date) >= crs.created_date
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
      LEFT JOIN (
          SELECT DISTINCT
              insurance_package_id,
              custom_insurance_grouping
              FROM looker_scratch.athenadwh_payers_clone
              WHERE custom_insurance_grouping IS NOT NULL
              GROUP BY 1,2) AS cig
          ON COALESCE(athena.insurance_package_id, sri.package_id) = cig.insurance_package_id
      GROUP BY 1,2,3,4,5,6;;

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

  dimension: member_id {
    type: string
    sql: ${TABLE}.member_id ;;
  }

  dimension: custom_insurance_grouping {
    type: string
    sql: ${TABLE}.custom_insurance_grouping ;;
  }
}
