view: subtotal_over {
  sql_table_name: (select '' as row_type union select null as row_type) ;; #This sql table name is used to create a duplicate copy of the data. When rowType is null, fields from this view will resolve to 'SUBTOTAL'

  #used in sql parameters below to re-assign values to 'SUBTOTAL' on subtotal rows
  dimension: row_type_checker {
    hidden:no
    sql: ${TABLE}.row_type ;;
  }
  # used for readability in sql_where of nested subtotal join
  dimension: row_type_description {
    hidden:no
    sql:coalesce(${TABLE}.row_type,'Subtotal');;
  }
}
