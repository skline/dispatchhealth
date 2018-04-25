view: insurance_classifications {
  sql_table_name: public.insurance_classifications ;;

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    hidden: yes
    timeframes: [
      raw
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: classification {
    alias: [name]
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension_group: updated {
    type: time
    hidden: yes
    timeframes: [
      raw
    ]
    sql: ${TABLE}.updated_at ;;
  }
}
