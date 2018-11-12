view: markets_user {
  sql_table_name: public.markets ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }


  dimension: id_adj {
    type: string
    hidden: yes
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' then 159
      else ${id} end;;
  }

  dimension: name {
    label: "Market Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: name_adj {
    label: "Adjusted Market Name"
    description: "The market name where WMFR has been combined with Denver"
    type: string
    sql: case when ${TABLE}.name = 'West Metro Fire Rescue' then 'Denver'
      else ${name} end;;
  }

  dimension: short_name {
    description: "The 3 character short market name"
    type: string
    sql: ${TABLE}.short_name ;;
  }

}
