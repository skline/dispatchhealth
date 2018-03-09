view: adwords_ad_clone {
  sql_table_name: looker_scratch.adwords_ad_clone ;;

  dimension: ad {
    type: string
    sql: ${TABLE}.ad ;;
  }

  dimension: ad_id {
    type: number
    sql: ${TABLE}.ad_id ;;
  }

  dimension: adwordsadgroupid {
    type: number
    value_format_name: id
    sql: ${TABLE}.adwordsadgroupid ;;
  }

  dimension: business_name {
    type: string
    sql: ${TABLE}.business_name ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: description_line_1 {
    type: string
    sql: ${TABLE}.description_line_1 ;;
  }

  dimension: description_line_2 {
    type: string
    sql: ${TABLE}.description_line_2 ;;
  }

  dimension: display_url {
    type: string
    sql: ${TABLE}.display_url ;;
  }

  dimension: headline {
    type: string
    sql: ${TABLE}.headline ;;
  }

  dimension: headline_1 {
    type: string
    sql: ${TABLE}.headline_1 ;;
  }

  dimension: headline_2 {
    type: string
    sql: ${TABLE}.headline_2 ;;
  }

  dimension: long_headline {
    type: string
    sql: ${TABLE}.long_headline ;;
  }

  dimension: path_1 {
    type: string
    sql: ${TABLE}.path_1 ;;
  }

  dimension: path_2 {
    type: string
    sql: ${TABLE}.path_2 ;;
  }

  dimension: short_headline {
    type: string
    sql: ${TABLE}.short_headline ;;
  }

  measure: count {
    type: count
    drill_fields: [business_name]
  }
}
