view: insurance_network_insurance_plans {
  sql_table_name: public.insurance_network_insurance_plans ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: insurance_network_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.insurance_network_id ;;
  }

  dimension: package_id {
    type: string
    sql: ${TABLE}.package_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, insurance_networks.id, insurance_networks.name]
  }
}
