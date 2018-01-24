view: provider_dimensions {
  sql_table_name: jasperdb.provider_dimensions ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: advanced_practice_provider_name {
    type: string
    sql: ${TABLE}.advanced_practice_provider_name ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: emt_name {
    type: string
    sql: ${TABLE}.emt_name ;;
  }

  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  dimension: virtual_doctor_name {
    type: string
    sql: ${TABLE}.virtual_doctor_name ;;
  }

  measure: count {
    type: count
    drill_fields: [id, virtual_doctor_name, emt_name, advanced_practice_provider_name]
  }

  dimension: shift_app_name {
    type: string
    sql:case when ${advanced_practice_provider_name} like "%DAVID MACKEY%" then 'Dave Mackey'
      when ${advanced_practice_provider_name} like '%ELIZABETH "ELLIE" NEISES%' then 'Ellie Neises'
      when ${advanced_practice_provider_name} like "%HEATHER HOUSTON RAHIM%" then 'Heather Rahim'
      when ${advanced_practice_provider_name} like "%DEEVAW ARTIS%"  then 'NDeevaw Artis'
      when ${advanced_practice_provider_name} like "%JENNY  COX%"  then 'Jenny Cox'
      else ${advanced_practice_provider_name}  end;;
  }
}
