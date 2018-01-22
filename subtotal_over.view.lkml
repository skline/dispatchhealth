view: subtotal_over {
  sql_table_name: (select '' as row_type union select null as row_type) ;; #This sql table name is used to create a duplicate copy of the data. When rowType is null, fields from this view will resolve to 'SUBTOTAL'

  #used in sql parameters below to re-assign values to 'Subtotal' on subtotal rows
  dimension: row_type_checker {
    hidden:no
    sql: ${TABLE}.row_type ;;
  }
  # used for readability in sql_where of nested subtotal join
  dimension: row_type_description {
    hidden:no
    order_by_field: row_type_description_order
    sql:coalesce(${TABLE}.row_type,'Subtotal');;
  }

  dimension: row_type_description_order {
    hidden:yes
    type:  number
    sql: coalesce(cast(coalesce(cast(${row_type_description} as float),-9999999999)||${row_type_checker} as float),9999999999);;
  }

}
