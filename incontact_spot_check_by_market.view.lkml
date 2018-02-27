view: incontact_spot_check_by_market {
    derived_table: {
      sql: select *
              from
              (select m.id as market_id, date(invoca_clone.start_time) as date_call,
              case when incontact_spot_check_clone.care_request is true then incontact_spot_check_clone.incontact_contact_id else null end as spot_check_care_requests
from looker_scratch.incontact_spot_check_clone
join looker_scratch.incontact_clone
on incontact_clone.contact_id=incontact_spot_check_clone.incontact_contact_id
join looker_scratch.invoca_clone
on abs(EXTRACT(EPOCH FROM incontact_clone.end_time)-EXTRACT(EPOCH FROM invoca_clone.start_time+invoca_clone.total_duration)) < 10
       and invoca_clone.caller_id::text like  CONCAT('%', incontact_clone.from_number ,'%')
join public.markets m
on m.id = (case when lower(invoca_clone.promo_number_description) like '%den%' then 159
     when lower(invoca_clone.promo_number_description) like '%cos%' then 160
     when lower(invoca_clone.promo_number_description) like '%phoe%' then 161
     when lower(invoca_clone.promo_number_description) like '%ric%'  then 164
     when lower(invoca_clone.promo_number_description)  like '%las%' then 162
     else 0 end)
 where incontact_spot_check_clone.care_request is true
group by 1,2,3) incontact_spot_check_by_market
                     ;;
    }

    measure: spot_check_care_requests {
      type: number
      sql: coalesce(count(distinct ${TABLE}.spot_check_care_requests),0) ;;
    }

    dimension: market_id {
      type: number
      sql: ${TABLE}.market_id ;;
    }

    dimension: date_call {
      type: date
      sql: ${TABLE}.date_call ;;
    }




}
