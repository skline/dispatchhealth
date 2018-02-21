view: date_hour_ref {

 dimension: date_hour_ref.dt {
   # dimension_parameters
   type: time
   timeframes: [date]
   sql: ${TABLE}.dt ;;
 }
 dimension: date_hour_ref.hr {
   type: number
   sql: ${TABLE}.hr ;;
 }
 measure: count {
   type: count
   sql: ${id} ;;
 }
}
