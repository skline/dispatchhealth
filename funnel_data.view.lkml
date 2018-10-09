view: funnel_data {
  derived_table: {
    sql: SELECT
     'Total Care Requests' AS resolved_category,
     care_request_count
    FROM care_request_flat
    UNION
    SELECT
    resolved_category,
    care_request_count
    FROM care_request_flat
    UNION SELECT 'Total', 0 ;;
  }

  dimension: resolved_category {
    type: string
    sql: ${TABLE}.resolved_category ;;
  }

  measure: care_request_count {
    type: sum
    sql: ${TABLE}.care_request_count ;;
  }
}
