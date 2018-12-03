view: intraday_care_requests {
  sql_table_name: public.intraday_care_requests ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: care_request_id {
    type: number
    sql: ${TABLE}.care_request_id ;;
  }

  dimension_group: created {
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

  dimension: accepted {
    type: yesno
    sql: ${accepted_time} is not null;;
  }

  dimension: complete {
    type: yesno
    sql: ${complete_time} is not null;;
  }

  dimension: resolved {
    type: yesno
    sql: ${complete_time} is null and ${archived_time} is not null;;
  }


  dimension: meta_data {
    type: string
    sql: ${TABLE}.meta_data ;;
  }

  dimension: etos {
    type: number
    sql: (${TABLE}.meta_data ->> 'etos')::int ;;
  }

  dimension: market_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'market_id')::int ;;
  }


  dimension: package_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'package_id')::int ;;
  }

  dimension: shift_team_id {
    type: number
    sql: (${TABLE}.meta_data ->> 'shift_team_id')::int ;;
  }

  dimension: current_status {
    type: string
    sql: ${TABLE}.meta_data ->> 'current_status' ;;
  }

  dimension: complete_comment {
    type: string
    sql: ${TABLE}.meta_data ->> 'complete_comment' ;;
  }

  dimension_group: etc {
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
    sql: (meta_data->>'etc')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: care_request_created {
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
    sql: (meta_data->>'created_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: accepted {
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
    sql: (meta_data->>'accepted_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: complete {
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
    sql: (meta_data->>'completed_at')::timestamp WITH TIME ZONE ;;
  }

  dimension_group: archived {
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
    sql: (meta_data->>'archived_at')::timestamp WITH TIME ZONE ;;
  }


  dimension_group: updated {
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

  dimension: stuck_inqueue {
    type: yesno
    sql: ${care_request_id} in(64317) ;;
  }
  measure: inqueue_crs {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }
  }

  measure: inqueue_crs_tricare {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(TC)TRICARE"
    }
    filters: {
      field: stuck_inqueue
      value: "no"
    }

  }

  measure: inqueue_crs_medicaid {
    type: count_distinct
    sql: ${intraday_care_requests.care_request_id};;
    filters: {
      field: accepted
      value: "no"
    }
    filters: {
      field: resolved
      value: "no"
    }
    filters: {
      field: current_status
      value: "requested"
    }
    filters: {
      field: primary_payer_dimensions_intra.custom_insurance_grouping
      value: "(MAID)MEDICAID"
    }

  }

  measure: inqueue_crs_medicaid_tricare {
    type: number
    sql:  ${inqueue_crs_medicaid}+${inqueue_crs_tricare};;
  }


  measure: count {
    type: count
    drill_fields: [id]
  }
}
