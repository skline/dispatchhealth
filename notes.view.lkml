view: notes {
  sql_table_name: public.notes ;;

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

  dimension_group: deleted {
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
    sql: ${TABLE}.deleted_at ;;
  }

  dimension: featured {
    type: yesno
    sql: ${TABLE}.featured ;;
  }

  dimension: in_timeline {
    type: yesno
    sql: ${TABLE}.in_timeline ;;
  }

  dimension: meta_data {
    type: string
    sql: ${TABLE}.meta_data ;;
  }

  dimension: note {
    type: string
    sql: ${TABLE}.note ;;
  }

  dimension: special_channel_note{
    type: yesno
    sql: ${note} like '%care management%' OR
${note} like '%case management%' OR
${note} like '%doctor%' OR
${note} like '%home health%' OR
${note} like '% rn %' OR
${note} like '%multicare%' OR
${note} like '%baycare%' OR
${note} like '% thr %' OR
${note} like '% ou %' OR
${note} like '%baystate%' OR
${note} like '%bon secours%' OR
${note} like '%valley%' OR
${note} like '%kelsey%' OR
${note} like '%centura%';;
  }

  measure: notes_aggregated {
    type: string
    sql: array_to_string(array_agg(DISTINCT ${note}), ' |') ;;
  }

  dimension: note_type {
    type: string
    sql: ${TABLE}.note_type ;;
  }

  dimension: er_911_alternative {
    description: "Medical necessity note is that patient would have called 911 or gone to ED"
    type: yesno
    sql: ${note} = 'The patient would have called 911 or gone to ED.' ;;
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

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
