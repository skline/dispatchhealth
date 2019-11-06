view: insurance_coalese {
    derived_table: {
      sql:select  care_requests.id as care_request_id,
         COALESCE(primary_payer_dimensions_clone.insurance_package_id, self_report_insurances.package_id) package_id_coalese,
         primary_payer_dimensions_clone.insurance_package_id as athena_package_id,
        self_report_insurances.package_id as self_report_package_id
        FROM care_requests
        join public.patients
        on patients.id=care_requests.patient_id
        left join (select  care_requests.id as care_request_id, package_id,  ROW_NUMBER() OVER(PARTITION BY care_requests.id
                                ORDER BY insurances.created_at desc) as rn
        FROM care_requests
        join public.patients
        on patients.id=care_requests.patient_id
        join public.insurances
        on care_requests.patient_id = insurances.patient_id AND insurances.priority = '1'
        AND insurances.patient_id IS NOT NULL
        and care_requests.created_at + interval '1' day >= insurances.created_at
        and insurances.package_id is not null
        and trim(insurances.package_id)!='')   self_report_insurances
        on self_report_insurances.care_request_id=care_requests.id and self_report_insurances.rn=1

       left join looker_scratch.visit_dimensions_clone
       ON care_requests.id = visit_dimensions_clone.care_request_id
       left join looker_scratch.transaction_facts_clone
       ON transaction_facts_clone.visit_dim_number = visit_dimensions_clone.visit_number
       AND transaction_facts_clone.voided_date IS NULL
        left join looker_scratch.primary_payer_dimensions_clone
        on transaction_facts_clone.primary_payer_dim_id = primary_payer_dimensions_clone.id
        GROUP BY 1,2,3,4
       ;;
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
