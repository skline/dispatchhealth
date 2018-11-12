view: channel_items_user {
  sql_table_name: public.channel_items ;;

  dimension: id {
    primary_key: yes
    type: number
    hidden: yes
    sql: ${TABLE}.id ;;
  }

  dimension: name {
    type: string
    sql: TRIM(INITCAP(${TABLE}.name)) ;;
  }

  dimension: source_name {
    type: string
    sql: ${TABLE}.source_name ;;
  }

  dimension: type_name {
    type: string
    sql: ${TABLE}.type_name ;;
  }

  dimension: sub_type {
    type: string
    sql: CASE
          WHEN ${source_name} LIKE 'Emergency Medical Service%' THEN ${name}
          WHEN ${source_name} = 'Direct Access' THEN ${source_name}
          WHEN ${source_name} = 'Healthcare Partners' THEN ${type_name}
          ELSE 'Undocumented'
        END ;;
  }


}
