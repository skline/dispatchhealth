view: narrow_network_providers {
  derived_table: {
    sql: SELECT
    CONCAT(inip.package_id::varchar, inw.market_id::varchar, nr.athena_id::varchar, nr.type) AS id,
    inip.insurance_network_id,
    inip.package_id,
    inw.market_id,
    nr.athena_id,
    nr.name,
    nr.type
    FROM public.insurance_network_insurance_plans inip
    LEFT JOIN public.insurance_network_network_referrals innr
        ON inip.insurance_network_id = innr.insurance_network_id
    LEFT JOIN public.network_referrals nr
        ON innr.network_referral_id = nr.id
    LEFT JOIN public.insurance_networks inw
        ON inip.insurance_network_id = inw.id
    WHERE innr.default IS TRUE AND inw.active IS TRUE
    GROUP BY 1,2,3,4,5,6,7 ;;

      indexes: ["id", "package_id", "market_id", "athena_id", "insurance_network_id"]
      sql_trigger_value: SELECT MAX(network_referral_id) FROM public.insurance_network_network_referrals ;;
    }

    dimension: id {
      primary_key: yes
      type: string
      sql: ${TABLE}.id ;;
    }

  dimension: package_id {
    type: number
    sql: ${TABLE}.package_id ;;
  }

  dimension: insurance_network_id {
    type: number
    sql: ${TABLE}.insurance_network_id ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }

  dimension: athena_id {
    type: number
    sql: ${TABLE}.athena_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: is_default_provider {
    type: yesno
    sql: ${athena_id} IS NOT NULL ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }
}
