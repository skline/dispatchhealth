view: rules_genders {
  sql_table_name: public.rules_genders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: gender_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.gender_id ;;
  }

  dimension: rule_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.rule_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, rules.id, genders.id, genders.name]
  }
}
