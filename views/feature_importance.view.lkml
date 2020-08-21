view: feature_importance {
  sql_table_name: bounce_back_risk.feature_importance ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."id" ;;
  }

  dimension: model_version {
    type: number
    sql: ${TABLE}."model_version" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."name" ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}."rank" ;;
  }

  dimension: value {
    type: number
    sql: ${TABLE}."value" ;;
  }

  measure: relative_importance {
    type: average
    sql: ${value} ;;
    value_format: "0.0000"
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
