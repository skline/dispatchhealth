view: zizzl_detailed_shift_hours {
  derived_table: {
    sql:
WITH shift_info AS (
SELECT
    st.id AS shift_team_id,
    st.start_time AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz AS shift_start,
    st.end_time AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz AS shift_end,
    users.id AS user_id,
    pp.position AS position,
    cars.name AS shift_name,
    mkt.id AS market_id,
    mkt.name AS market_name,
    slt.market_id AS loaned_market_id,
    mktl.name AS loaned_market,
    MAX(slt.created_at) AS start_loaned,
    MAX(slf.created_at) AS stop_loaned,
    RANK() OVER(PARTITION BY users.id, DATE(st.start_time AT TIME ZONE 'UTC' AT TIME ZONE tz.pg_tz) ORDER BY st.start_time) AS row_num
    FROM public.shift_teams st
    LEFT JOIN public.shift_team_members stm
        ON st.id = stm.shift_team_id
    LEFT JOIN public.users
        ON stm.user_id = users.id
    LEFT JOIN public.provider_profiles pp
        ON users.id = pp.user_id
    LEFT JOIN public.cars
        ON st.car_id = cars.id
    LEFT JOIN public.markets mkt
        ON cars.market_id = mkt.id
    LEFT JOIN looker_scratch.timezones tz
        ON mkt.sa_time_zone = tz.rails_tz
    LEFT JOIN public.shift_team_market_assignment_logs slt
        ON st.id = slt.shift_team_id AND slt.lend is TRUE
    LEFT JOIN public.shift_team_market_assignment_logs slf
        ON st.id = slf.shift_team_id AND slf.lend is FALSE
    LEFT JOIN public.markets mktl
        ON slt.market_id = mktl.id
    GROUP BY 1,2,3,4,5,6,7,8,9,10),
sh AS (
SELECT
            employee_id,
            first_name,
            last_name,
            employee_ein,
            employee_job_title,
            counter_date,
            SUM(counter_hours) AS counter_hours,
            SUM(gross_pay) AS gross_pay,
            CASE
                WHEN counter_name = 'Regular' AND provider_type = 'APP' THEN 'Salary Plus'
                ELSE counter_name
            END as counter_name,
            location,
            provider_type,
            position,
            activities,
            partner,
            time_off,
            DATE(created_at) AS updated,
            ROW_NUMBER() OVER(PARTITION BY employee_id, counter_date, counter_name ORDER BY DATE(updated_at) DESC) AS row_num
        FROM looker_scratch.zizzl_detailed_shift_hours
        GROUP BY 1,2,3,4,5,6,9,10,11,12,13,14,15,16, counter_name, DATE(updated_at))

SELECT DISTINCT
    CONCAT(sh.employee_id::varchar,sh.employee_ein,counter_date::varchar,sh.counter_name,sh.position,sh.activities) AS primary_key,
    sh.employee_id,
    sh.first_name,
    sh.last_name,
    sh.employee_job_title,
    sh.provider_type,
    sh.counter_date,
    sh.counter_hours,
    sh.gross_pay,
    sh.counter_name,
    sh.location,
    sh.position AS shift_name,
    sh.activities,
    sh.partner,
    sh.time_off,
    shift_info.shift_team_id,
    shift_info.shift_start AS local_shift_start,
    shift_info.shift_end AS local_shift_end,
    --shift_info.user_id,
    shift_info.position,
    shift_info.shift_name AS car_name,
    shift_info.market_id,
    shift_info.market_name,
    shift_info.loaned_market_id,
    shift_info.loaned_market
    FROM sh
    LEFT JOIN shift_info
        ON shift_info.user_id = sh.employee_id AND
        DATE(shift_info.shift_start) = sh.counter_date AND shift_info.row_num = 1
    WHERE sh.row_num = 1
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24
    ORDER BY 1 ;;

  sql_trigger_value: select count(*) from looker_scratch.zizzl_detailed_shift_hours ;;
  indexes: ["shift_team_id", "employee_id"]
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    hidden: no
    sql: ${TABLE}.primary_key ;;
  }

    dimension:shift_team_id {
      type: number
      description: "The primary key from the public shift_teams view"
      sql: ${TABLE}.shift_team_id ;;
    }
    dimension_group: local_shift_start {
      type: time
      description: "The local shift start time"
      convert_tz: no
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.local_shift_start ;;
    }
    dimension_group: local_shift_end {
      type: time
      description: "The local time that the shift ends"
      convert_tz: no
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.local_shift_end ;;
    }
    # dimension: user_id {
    #   type: number
    #   description: "The primary key to the public users view"
    #   sql: ${TABLE}.user_id ;;
    # }
    dimension: position {
      type: string
      description: "The position from the provider profiles position view (e.g. 'advanced practice provider')"
      sql: ${TABLE}.position ;;
    }
  dimension: employee_job_title {
    type: string
    description: "The employee's default job title"
    sql: ${TABLE}.employee_job_title ;;
  }
  dimension: care_team_employee {
    type: yesno
    description: "A flag indicating the employee is part of the CARE Team"
    sql: ${employee_job_title} LIKE 'CARE %'   ;;
  }
    dimension: car_name {
      type: string
      description: "The name of the car (e.g. 'DEN01')"
      sql: ${TABLE}.car_name ;;
    }
    dimension: market_id {
      type: number
      description: "The primary key from the public markets view"
      sql: ${TABLE}.market_id ;;
    }
    dimension: market_name {
      type: string
      description: "The long name of the market (e.g. 'Denver')"
      sql: ${TABLE}.market_name ;;
    }
    dimension: loaned_market_id {
      type: number
      description: "The market ID to which the shift was loaned"
      sql: ${TABLE}.loaned_market_id ;;
    }
    dimension: loaned_market {
      type: string
      description: "The long name of the market to which the shift was loaned"
      sql: ${TABLE}.loaned_market ;;
    }
    dimension: market_worked {
      type: string
      description: "The long name of the market where the shift worked, taking into account shift lending"
      sql: COALESCE(${loaned_market}, ${market_name}, ${location}) ;;
    }
    dimension: employee_id {
      type: number
      description: "The primary key from the public users view"
      sql: ${TABLE}.employee_id ;;
    }
    dimension: first_name {
      type: string
      description: "Employee first name"
      sql: ${TABLE}.first_name ;;
    }
   dimension: last_name {
    type: string
    description: "Employee last name"
    sql: ${TABLE}.last_name ;;
    }
  dimension: provider_type {
    type: string
    description: "Provider type (e.g. 'APP','DHMT') if applicable"
    sql: CASE WHEN ${TABLE}.provider_type IS NULL AND ${position} = 'advanced practice provider' THEN 'APP'
              WHEN ${TABLE}.provider_type IS NULL AND ${position} = 'emt' THEN 'DHMT'
              ELSE ${TABLE}.provider_type
         END ;;
    # sql: ${TABLE}.provider_type ;;
  }
  dimension_group: counter {
    type: time
    description: "The Zizzl employee shift date"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.counter_date ;;
  }

  dimension: date_string {
    type: string
    hidden: yes
    sql: ${TABLE}.counter_date::varchar ;;
  }

   dimension: counter_hours {
    type: number
    value_format: "#,##0.00"
    description: "The punched hours worked"
    sql: ${TABLE}.counter_hours ;;
    }

    dimension: counter_hours_range {
      type: string
      sql: case when ${counter_hours} >= 14 then 'Greater than 14 hours'
                when ${counter_hours} >= 9.5 and  ${counter_hours} < 14 then 'Greater than 9.5 and less than 14 hours'
                when ${counter_hours} < 9.5  and ${counter_hours} >= 8.5  then 'Greater 8.5 and less than 9.5 hours'
                when ${counter_hours} < 8.5  and ${counter_hours} >= 7.5  then 'Greater 7.5 and less than 8.5 hours'
                when ${counter_hours} < 7.5 then '7.5 or less hours' else null end;;
    }

  dimension: counter_hours_range_simple {
    type: string
    sql: case when ${counter_hours} >= 14 then 'Greater than 14 hours'
                when ${counter_hours} >= 11 and  ${counter_hours} < 14 then 'Greater than 11 and less than 14 hours'
                when ${counter_hours} >= 9.5 and  ${counter_hours} <11 then 'Greater than 9.5 and less than 11 hours'
                when ${counter_hours} < 9.5   then '9.5 or less hours'
            else null end;;
  }

    measure: count_distinct {
      type: count_distinct
      sql: ${primary_key} ;;
      sql_distinct_key: ${primary_key} ;;
    }

  measure: average_direct_hours {
    value_format: "0.00"
    type: average_distinct
    sql: ${counter_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    filters: {
      field: direct_shift_hours
      value: "yes"
    }
  }

  measure: sum_total_hours {
    type: sum_distinct
    description: "The sum of all hours worked"
    sql: ${counter_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "#,##0.00"
    filters: {
      field: regular_shift_hours
      value: "yes"
    }
  }

  measure: sum_total_pay {
    type: sum_distinct
    description: "The sum of all gross pay for all hours worked"
    sql: ${gross_pay} ;;
    sql_distinct_key: ${primary_key};;
    value_format: "$#,##0.00"
  }

    measure: sum_direct_hours {
      type: sum_distinct
      description: "The sum of all direct hours worked"
      sql: ${counter_hours} ;;
      sql_distinct_key: ${primary_key} ;;
      value_format: "#,##0.00"
      filters: {
        field: direct_shift_hours
        value: "yes"
      }
    }

  measure: sum_admin_hours {
    type: sum_distinct
    description: "The sum of all admin hours worked"
    sql: ${counter_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "#,##0.00"
    filters: {
      field: admin_shift_hours
      value: "yes"
    }
  }

  measure: sum_direct_care_team_hours {
    type: sum_distinct
    description: "The sum of all direct CARE Team hours worked"
    sql: ${counter_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "#,##0.00"
    filters: {
      field: direct_care_team_hours
      value: "yes"
    }
  }

  measure: sum_special_hours {
    type: sum_distinct
    description: "The sum of all hours worked under special counter (Holiday, Overtime, etc.)"
    sql: ${counter_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "#,##0.00"
    filters: {
      field: special_direct_hours
      value: "yes"
    }
  }

  measure: sum_pto_hours {
    type: sum_distinct
    description: "The sum of all hours worked under special counter (Holiday, Overtime, etc.)"
    sql: ${counter_hours} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "#,##0.00"
    filters: {
      field: pto_hours
      value: "yes"
    }
  }

  measure: sum_non_direct_hours {
    type: sum
    description: "The sum of all non-direct hours (Training, PTO, Bereavement, etc.)"
    sql: ${counter_hours} ;;
    value_format: "#,##0.00"
    filters: {
      field: non_direct_hours
      value: "yes"
    }
  }

   dimension: gross_pay {
    type: number
    value_format: "$#,##0.00"
    description: "The amount paid for hours worked"
    sql: ${TABLE}.gross_pay ;;
    }

  measure: sum_direct_pay {
    type: sum_distinct
    description: "The sum of all gross pay for direct hours worked"
    sql: ${gross_pay} ;;
    sql_distinct_key: ${primary_key};;
    value_format: "$#,##0.00"
    filters: {
      field: direct_shift_hours
      value: "yes"
    }
  }

  measure: sum_direct_care_team_pay {
    type: sum_distinct
    description: "The sum of all gross pay for direct hours worked"
    sql: ${gross_pay} ;;
    sql_distinct_key: ${primary_key};;
    value_format: "$#,##0.00"
    filters: {
      field: direct_care_team_hours
      value: "yes"
    }
  }

  measure: sum_special_pay {
    type: sum_distinct
    description: "The sum of all gross pay for special hours worked (Overtime, Holiday, etc.)"
    sql: ${gross_pay} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "$#,##0.00"
    filters: {
      field: special_direct_hours
      value: "yes"
    }
  }

  measure: sum_pto_pay {
    type: sum_distinct
    description: "The sum of all PTO pay"
    sql: ${gross_pay} ;;
    sql_distinct_key: ${primary_key} ;;
    value_format: "$#,##0.00"
    filters: {
      field: pto_hours
      value: "yes"
    }
  }

  measure: sum_non_direct_pay {
    type: sum
    description: "The sum of all gross pay for non-direct hours worked (Training, Overtime, Holiday, etc.)"
    sql: ${gross_pay} ;;
    value_format: "$#,##0.00"
    filters: {
      field: non_direct_hours
      value: "yes"
    }
  }

   dimension: counter_name {
    type: string
    description: "The pay category (e.g. 'Regular','Overtime', etc.)"
    sql: ${TABLE}.counter_name ;;
    }

    dimension: regular_shift_hours {
      type: yesno
      description: "A flag indicating regular paid hours. Additional pay may be added for the same hours"
      sql: ${counter_name} IN ('Regular','Salary Plus') AND ${activities} IS NULL ;;
    }

  dimension: direct_shift_hours {
    type: yesno
    description: "A flag indicating hours worked for direct costs. Administration and training are excluded."
    sql: ${counter_name} IN ('Regular','Salary Plus')
         AND (${shift_name} != 'Administration' OR ${shift_name} IS NULL)
         AND (${shift_name} LIKE 'DHMT/%' OR ${shift_name} LIKE 'NP/PA/%') ;;
  }

  dimension: admin_shift_hours {
    type: yesno
    description: "A flag indicating hours worked for Administration costs."
    sql: ${counter_name} IN ('Regular','Salary Plus')
         AND (lower(${shift_name}) = 'administration')
          ;;
  }

  dimension: direct_care_team_hours {
    type: yesno
    description: "A flag indicating hours worked for direct CARE Team costs."
    sql: TRIM(${counter_name}) IN ('Regular')
         AND (${shift_name} NOT LIKE 'DHMT/%' OR ${shift_name} IS NULL OR ${shift_name}='') ;;
  }

  dimension: special_direct_hours {
    type: yesno
    description: "A flag indicating special paid hours (e.g. Ambassador, Solo Shift, 1.5 Time, etc.)"
    sql: ${counter_name} IN ('Overtime 0.5','Overtime','Holiday Worked 0.5','Double Pay','Ambassador',
                             'Solo Shift','On Call Premium','Time and Half');;
  }

  dimension: non_direct_hours {
    type: yesno
    description: "A flag indicating non-direct hours (e.g. Training, Bereavement, PTO, etc."
    sql: ${counter_name} IN ('PTO','Bereavement','Training') ;;
  }



  dimension: pto_hours {
    type: yesno
    description: "A flag indicating PTO hours"
    sql: ${counter_name} = 'PTO' ;;
  }

  dimension: training_hours {
    type: yesno
    description: "A flag indicating training hours"
    sql: ${counter_name} IN ('Training') ;;
  }


   dimension: location {
    type: string
    description: "The market location of the shift (or 'Corporate/Headquarters')"
    sql: CASE WHEN ${TABLE}.location LIKE 'Ridgewood%' THEN 'Ridgewood'
         ELSE ${TABLE}.location
         END;;
    }
   dimension: shift_name {
    type: string
    description: "The Zizzl shift name (e.g. 'NP/PA/DEN01')"
    sql: CASE
          WHEN ${TABLE}.shift_name IS NULL AND ${provider_type} = 'APP' THEN CONCAT('NP/PA/',${car_name})
          WHEN ${TABLE}.shift_name IS NULL AND ${provider_type} = 'DHMT' THEN CONCAT('DHMT/',${car_name})
          ELSE ${TABLE}.shift_name
        END ;;
    }
   dimension: activities {
    type: string
    description: "A descriptor of the type of shift worked (e.g. 'On Call', etc.)"
    sql: ${TABLE}.activities ;;
    }
   dimension: partner {
    type: string
    description: "A descriptor of the partner if applicable (e.g. 'WMFR')"
    sql: ${TABLE}.partner ;;
    }
   dimension: time_off {
    type: string
    description: "A descriptor of PTO that was paid"
    sql: ${TABLE}.time_off ;;
    }

  measure: dashboard_vs_zizzl_diff {
    type: number
    value_format: "0.0"
    sql: ${shift_teams.sum_shift_hours}::float  - ${zizzl_detailed_shift_hours.sum_direct_hours}::float  ;;

  }

}
