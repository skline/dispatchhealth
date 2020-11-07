view: collective_medical_admit_emergency_and_inpatient_within_24_hours {
  derived_table: {
    sql: select
        DISTINCT cros.care_request_id,
        em.patient_id
from
        (select
                patient_id,
                major_class,
                admit_date
        from collective_medical.collective_medical
        where lower(major_class) = 'emergency'
        order by admit_date) em
inner join
        (select
                patient_id,
                major_class,
                admit_date
        from collective_medical.collective_medical
        where lower(major_class) = 'inpatient'
        order by admit_date) ip
        on em.patient_id = ip.patient_id
INNER JOIN (
        SELECT
            cr.id AS care_request_id,
            cr.patient_id AS dh_patient_id,
            crs.on_scene_date
        FROM
            public.care_requests cr
            INNER JOIN (
                SELECT
                    care_request_id,
                    MAX(started_at) AS on_scene_date
                FROM
                    public.care_request_statuses
                WHERE
                    name = 'on_scene'
                    AND deleted_at IS NULL
                GROUP BY
                    1) AS crs ON crs.care_request_id = cr.id) cros ON em.patient_id = cros.dh_patient_id
where ((EXTRACT(EPOCH FROM ip.admit_date)-EXTRACT(EPOCH FROM em.admit_date)) / 3600) <= 24 AND ip.admit_date >= em.admit_date AND em.admit_date >= cros.on_scene_date AND ((EXTRACT(EPOCH FROM em.admit_date)-EXTRACT(EPOCH FROM cros.on_scene_date)) / 3600) <= 720
order by cros.care_request_id, em.patient_id ;;

    # Run trigger every 2 hours
    sql_trigger_value:  SELECT MAX(id) FROM collective_medical.collective_medical;;
    indexes: ["care_request_id", "patient_id"]
  }


  dimension: care_request_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.care_request_id ;;
  }

  dimension: dh_patient_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

}
