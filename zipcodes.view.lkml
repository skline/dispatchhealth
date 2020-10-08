view: zipcodes {
  sql_table_name: public.zipcodes ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: billing_city_id {
    type: number
    sql: ${TABLE}.billing_city_id ;;
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

  dimension_group: deleted_at {
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

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: safety_warning {
    type: yesno
    sql: ${TABLE}.safety_warning IS TRUE ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: market_id {
    type: number
    sql: ${TABLE}.market_id ;;
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

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: denver_office_service_area {
    type: string
    description: "An indicator of zips serviced by the RiNo vs. South Metro office Zip Codes"
    sql: CASE WHEN ${zip} IN ('80112','80111','80124',
'80130','80237','80122','80121','80015','80126','80014','80231','80113',
'80222','80134','80013','80016','80120','80129','80012','80108','80017',
'80110','80138','80123','80018','80128','80125','80109','80127','80104',
'80226','80227','80235','80236','80219','80223','80228','80232','80210') THEN 'South Office'
WHEN ${zip} IN ('80224','80247','80246','80230','80209','80010','80220',
'80206','80045','80011','80218','80203','80207','80238','80205','80204','80202',
'80239','80216','80211','80214','80019','80212','80215','80221','80033',
'80229','80030','80002','80003','80249','80022',
'80640','80260','80004','80401','80031','80233','80005','80234',
'80241','80021','80007','80601','80020','80602','80023','80027',
'80026','80303','80516','80305','80310','80301','80304','80302') THEN 'RiNo Office'
ELSE NULL
END;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
