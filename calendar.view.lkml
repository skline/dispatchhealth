view: cal454 {
  derived_table: {
    sql: WITH calendar AS (
      SELECT
        transdate,
        year454 AS fiscalyear,
        quarter454 AS fiscalquart,
        month454 AS fiscalmonth,
        week454 AS fiscalweek,
        dow454 AS fiscaldow,
        max(week454) OVER (PARTITION BY year454) lastweekofyear
      FROM public.cal454
      ),
      today AS (
      SELECT *
      FROM calendar
      WHERE {% condition as_of_date %} transdate {% endcondition %}
      )
    SELECT 'week-to-date' date_group, wtd.transdate
    FROM calendar wtd
    INNER JOIN
    today
    ON wtd.fiscalyear = today.fiscalyear
    AND wtd.fiscalweek = today.fiscalweek
    AND wtd.fiscaldow <= today.fiscaldow
    UNION ALL
    SELECT 'week-to-date-last-year' date_group, wtd.transdate
    FROM calendar wtd
    INNER JOIN
    today
    ON wtd.fiscalyear = today.fiscalyear::integer - 1
    AND wtd.fiscalweek = today.fiscalweek
    AND wtd.fiscaldow <= today.fiscaldow
    UNION ALL
    SELECT 'month-to-date' date_group, mtd.transdate
    FROM calendar mtd
    INNER JOIN
    today
    ON mtd.fiscalyear = today.fiscalyear
    AND mtd.fiscalmonth = today.fiscalmonth
    AND (
          mtd.fiscalweek < today.fiscalweek
          OR
          (
            mtd.fiscalweek = today.fiscalweek
            AND mtd.fiscaldow <= today.fiscaldow
          )
        )
    UNION ALL
    SELECT 'month-to-date-last-year' date_group, mtd.transdate
    FROM calendar mtd
    INNER JOIN
    today
    ON mtd.fiscalyear = today.fiscalyear::integer - 1
    AND mtd.fiscalmonth = today.fiscalmonth
    AND (
          mtd.fiscalweek < today.fiscalweek
          OR
          (
            mtd.fiscalweek = today.fiscalweek
            AND mtd.fiscaldow <= today.fiscaldow
          )
        )
    UNION ALL
    SELECT 'quarter-to-date' date_group, qtd.transdate
    FROM calendar qtd
    INNER JOIN
    today
    ON qtd.fiscalyear = today.fiscalyear
    AND qtd.fiscalquart = today.fiscalquart
    AND (
          qtd.fiscalweek < today.fiscalweek
          OR
          (
            qtd.fiscalweek = today.fiscalweek
            AND qtd.fiscaldow <= today.fiscaldow
          )
        )
    UNION ALL
    SELECT 'quarter-to-date-last-year' date_group, qtd.transdate
    FROM calendar qtd
    INNER JOIN
    today
    ON qtd.fiscalyear = today.fiscalyear::integer - 1
    AND qtd.fiscalquart = today.fiscalquart
    AND (
          qtd.fiscalweek < today.fiscalweek
          OR
          (
            qtd.fiscalweek = today.fiscalweek
            AND qtd.fiscaldow <= today.fiscaldow
          )
        )
    UNION ALL
    SELECT 'year-to-date' date_group, ytd.transdate
    FROM calendar ytd
    INNER JOIN
    today
    ON ytd.fiscalyear = today.fiscalyear
    AND (
          ytd.fiscalweek < today.fiscalweek
          OR
          (
            ytd.fiscalweek = today.fiscalweek
            AND ytd.fiscaldow <= today.fiscaldow
          )
        )
    UNION ALL
    SELECT 'year-to-date-last-year' date_group, ytd.transdate
    FROM calendar ytd
    INNER JOIN
    today
    ON ytd.fiscalyear = today.fiscalyear::integer - 1
    AND (
          ytd.fiscalweek < today.fiscalweek
          OR
          (
            ytd.fiscalweek = today.fiscalweek
            AND ytd.fiscaldow <= today.fiscaldow
          )
        )
    UNION ALL
    SELECT 'last-week' date_group, lw.transdate
    FROM calendar lw
    INNER JOIN
    today
    ON
      CASE today.fiscalweek
        WHEN 1
          THEN lw.fiscalyear = today.fiscalyear::integer - 1
            AND lw.fiscalweek = lw.lastweekofyear
        ELSE
          lw.fiscalyear = today.fiscalyear
          AND lw.fiscalweek = today.fiscalweek::integer - 1
      END
    UNION ALL
    SELECT 'last-month' date_group, lm.transdate
    FROM calendar lm
    INNER JOIN
    today
    ON
      CASE today.fiscalmonth
        WHEN 1
          THEN lm.fiscalyear = today.fiscalyear::integer - 1
            AND lm.fiscalmonth = 12
        ELSE
          lm.fiscalyear = today.fiscalyear
          AND lm.fiscalmonth = today.fiscalmonth::integer - 1
      END
    UNION ALL
    SELECT 'last-quarter' date_group, lq.transdate
    FROM calendar lq
    INNER JOIN
    today
    ON
      CASE today.fiscalquart
        WHEN 1
          THEN lq.fiscalyear = today.fiscalyear::integer - 1
            AND lq.fiscalquart = 4
        ELSE
          lq.fiscalyear = today.fiscalyear
          AND lq.fiscalquart = today.fiscalquart::integer - 1
      END
    UNION ALL
    SELECT 'last-year' date_group, ly.transdate
    FROM calendar ly
    INNER JOIN
    today
    ON ly.fiscalyear = today.fiscalyear::integer - 1
    ORDER BY date_group
     ;;
  }
}
