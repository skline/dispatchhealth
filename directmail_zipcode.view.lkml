view: directmail_zipcode {
  sql_table_name: looker_scratch.directmail_zipcode ;;

  dimension: counts {
    type: number
    sql: ${TABLE}.Counts ;;
  }

  dimension: market {
    type: string
    sql: ${TABLE}.Market ;;
  }

  dimension: slm_a_campaign {
    type: string
    sql: ${TABLE}.SLM_aCampaign ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.Zip ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
