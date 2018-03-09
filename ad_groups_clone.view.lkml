view: ad_groups_clone {
  sql_table_name: looker_scratch.ad_groups_clone ;;

  dimension: ad_group_name {
    type: string
    sql: ${TABLE}.ad_group_name ;;
  }

  dimension: adwordsadgroupid {
    type: number
    value_format_name: id
    sql: ${TABLE}.adwordsadgroupid ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  measure: count {
    type: count
    drill_fields: [ad_group_name]
  }
}
