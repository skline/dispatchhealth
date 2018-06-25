view: request_type_dimensions {
  sql_table_name: jasperdb.request_type_dimensions ;;

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    hidden: yes
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

  dimension: request_type {
    type: string
    sql: ${TABLE}.request_type ;;
  }

  dimension: request_type_grouped {
    description: "The request type, where mobile and android are combined"
    type: string
    sql: CASE
          WHEN ${request_type} LIKE '%mobile%' THEN 'mobile'
          ELSE ${request_type}
        END;;
  }

  dimension: phone_requests {
    type: yesno
    sql: ${request_type} = 'phone' ;;
  }

  dimension: web_requests {
    type: yesno
    sql: ${request_type} = 'web' ;;
  }

  dimension: mobile_requests {
    type: yesno
    sql: ${request_type} LIKE 'mobile' ;;
  }

  dimension_group: updated {
    hidden: yes
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

  measure: count {
    type: count
    drill_fields: [id]
  }
}
