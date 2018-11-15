view: insurance_classifications {
  sql_table_name: public.insurance_classifications ;;

  dimension: id {
    primary_key: yes
    hidden: no
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

  dimension: exp_allowable {
    type: number
    sql: CASE
          WHEN ${id} = 2 THEN 261
          WHEN ${id} = 3 THEN 239
          WHEN ${id} = 4 THEN 131
          WHEN ${id} = 5 THEN 154
          WHEN ${id} = 6 THEN 220
          WHEN ${id} = 8 THEN 128
          ELSE 200
        END
          ;;
  }

  measure: avg_exp_allowable {
    type: average
    sql: ${exp_allowable} ;;
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
