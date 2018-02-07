view: adwords_call_data {
  sql_table_name: looker_scratch.adwords_call_data ;;

  dimension_group: end {
    convert_tz: no
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
    sql: ${TABLE}.end_time ;;
  }

  dimension: end_time_raw {
    type: string
    sql: ${TABLE}.end_time ;;
  }

  dimension: end_time_plus_one {
    type: string
    sql: ${TABLE}.end_time+1 ;;
  }

  dimension: end_time_minus_one {
    type: string
    sql: ${TABLE}.end_time-1 ;;
  }

  dimension: seconds {
    type: number
    sql: ${TABLE}.seconds ;;
  }

  dimension_group: start {
    convert_tz: no
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
    sql: ${TABLE}.start_time ;;
  }

  dimension: start_time_raw {
    type: string
    sql: ${TABLE}.start_time ;;
  }
  measure: average_call_time{
    type: number
    sql: round(avg(${seconds}),1);;
  }


    dimension: ad {
      type: string
      sql: ${TABLE}.ad ;;
    }

    dimension: ad_group {
      type: string
      sql: ${TABLE}.ad_group ;;
    }

    dimension: ad_label {
      type: number
      sql: ${TABLE}.ad_label ;;
    }

    dimension: area_code {
      type: number
      sql: ${TABLE}.area_code ;;
    }

    dimension: bussiness_name {
      type: string
      sql: ${TABLE}.bussiness_name ;;
    }

    dimension: campaign {
      type: string
      sql: ${TABLE}.campaign ;;
    }

    dimension: desciption_1 {
      type: string
      sql: ${TABLE}.desciption_1 ;;
    }

    dimension: description {
      type: string
      sql: ${TABLE}.description ;;
    }

    dimension: description_2 {
      type: string
      sql: ${TABLE}.description_2 ;;
    }

    dimension: display_url {
      type: string
      sql: ${TABLE}.display_url ;;
    }

    dimension: final_url {
      type: string
      sql: ${TABLE}.final_url ;;
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

    dimension: keyword_final_url {
      type: string
      sql: ${TABLE}.keyword_final_url ;;
    }

    dimension: long_headline {
      type: string
      sql: ${TABLE}.long_headline ;;
    }

    dimension: mobile_final_url {
      type: string
      sql: ${TABLE}.mobile_final_url ;;
    }

    dimension: path_1 {
      type: string
      sql: ${TABLE}.path_1 ;;
    }

    dimension: path_2 {
      type: string
      sql: ${TABLE}.path_2 ;;
    }

    dimension: quality_score {
      type: number
      sql: ${TABLE}.quality_score ;;
    }

    dimension: search_keyword {
      type: string
      sql: ${TABLE}.search_keyword ;;
    }


    dimension: short_headline {
      type: string
      sql: ${TABLE}.short_headline ;;
    }



    measure: count {
      type: count
      drill_fields: [bussiness_name]
    }
  }
