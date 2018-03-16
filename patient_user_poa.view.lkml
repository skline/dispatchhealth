view: patient_user_poa {
    label: "patient, user, poa phone number(s)"
    # Or, you could make this view a derived table, like this:
    derived_table: {
      sql: select *
        from
        (select p.id as patient_id,  p.mobile_number as patient_number,  poa.phone as poa_number
from public.patients p
left join public.power_of_attorneys poa
on poa.patient_id=p.id) poa
               ;;


       indexes: ["patient_id"]
      }
 dimension: patient_id {
  type: number
  sql: ${TABLE}.patient_id ;;
}

      dimension: patient_number {
        type: number
        sql: ${TABLE}.patient_number ;;
      }


  dimension: poa_number {
    type: number
    sql: ${TABLE}.poa_number ;;
  }
    }
