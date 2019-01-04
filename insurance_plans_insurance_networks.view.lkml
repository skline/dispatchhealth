view: insurance_plans_insurance_networks {
  derived_table: {
    sql: SELECT
      ip.id,
      ip.name,
      ip.package_id,
      ntw.*
    FROM public.insurance_plans ip
    LEFT JOIN
            (SELECT
                    inip.package_id AS network_package_id,
                    n.id AS network_id,
                    s.id AS state_id,
                    n.name AS network_name,
                    n.market_id
            FROM public.insurance_network_insurance_plans inip
            LEFT JOIN public.insurance_networks n
              ON inip.insurance_network_id = n.id
            LEFT JOIN public.markets m
              ON n.market_id = m.id
            LEFT JOIN public.states s
              ON m.state = s.abbreviation) AS ntw
      ON ip.package_id = ntw.network_package_id AND ip.state_id = ntw.state_id
      ORDER BY ip.package_id ;;

    sql_trigger_value: SELECT MAX(id) FROM insurance_plans ;;
    indexes: ["id"]
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: package_id {
    type: string
    sql: ${TABLE}.package_id ;;
  }

  dimension: network_package_id {
    type: string
    sql: ${TABLE}.network_package_id ;;
  }

  dimension: network_id {
    type: number
    sql: ${TABLE}.network_id ;;
  }

  dimension: state_id {
    type: number
    sql: ${TABLE}.state_id ;;
  }

  dimension: network_name {
    type: string
    sql: ${TABLE}.network_name ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
  }




}
