view: diversion_flat {
  derived_table: {
   sql:
  SELECT DISTINCT
  d.diagnosis_code,
  d.diversion_type_id,
  dc1.diversion AS dc1,
  dc2.diversion AS dc2,
  dc3.diversion AS dc3,
  dc4.diversion AS dc4,
  dc5.diversion AS dc5,
  dc6.diversion AS dc6,
  dc7.diversion AS dc7,
  dc8.diversion AS dc8,
  dc9.diversion AS dc9,
  dc10.diversion AS dc10,
  dc11.diversion AS dc11,
  dc12.diversion AS dc12,
  dc13.diversion AS dc13,
  dc14.diversion AS dc14,
  dc15.diversion AS dc15,
  dc16.diversion AS dc16,
  dc17.diversion AS dc17,
  dc18.diversion AS dc18,
  dc19.diversion AS dc19,
  dc21.diversion AS dc20,
  dc21.diversion AS dc21,
  dc22.diversion AS dc22,
  dc23.diversion AS dc23,
  dc24.diversion AS dc24,
  dc25.diversion AS dc25,
  dc26.diversion AS dc26,
  dc27.diversion AS dc27,
  dc28.diversion AS dc28,
  dc29.diversion AS dc29,
  dc30.diversion AS dc30,
  dc31.diversion AS dc31,
  dc32.diversion AS dc32,
  dc33.diversion AS dc33,
  dc34.diversion AS dc34,
  dc35.diversion AS dc35,
  dc36.diversion AS dc36,
  dc37.diversion AS dc37,
  dc38.diversion AS dc38,
  dc39.diversion AS dc39,
  dc40.diversion AS dc40,
  dc41.diversion AS dc41
  FROM (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id
    FROM looker_scratch.diversion
    GROUP BY 1,2) AS d
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 1
    GROUP BY 1,2,3) AS dc1
  ON d.diagnosis_code = dc1.diagnosis_code AND d.diversion_type_id = dc1.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 2
    GROUP BY 1,2,3) AS dc2
  ON d.diagnosis_code = dc2.diagnosis_code AND d.diversion_type_id = dc2.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 3
    GROUP BY 1,2,3) AS dc3
  ON d.diagnosis_code = dc3.diagnosis_code AND d.diversion_type_id = dc3.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 4
    GROUP BY 1,2,3) AS dc4
  ON d.diagnosis_code = dc4.diagnosis_code AND d.diversion_type_id = dc4.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 5
    GROUP BY 1,2,3) AS dc5
  ON d.diagnosis_code = dc5.diagnosis_code AND d.diversion_type_id = dc5.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 6
    GROUP BY 1,2,3) AS dc6
  ON d.diagnosis_code = dc6.diagnosis_code AND d.diversion_type_id = dc6.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 7
    GROUP BY 1,2,3) AS dc7
  ON d.diagnosis_code = dc7.diagnosis_code AND d.diversion_type_id = dc7.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 8
    GROUP BY 1,2,3) AS dc8
  ON d.diagnosis_code = dc8.diagnosis_code AND d.diversion_type_id = dc8.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 9
    GROUP BY 1,2,3) AS dc9
  ON d.diagnosis_code = dc9.diagnosis_code AND d.diversion_type_id = dc9.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 10
    GROUP BY 1,2,3) AS dc10
  ON d.diagnosis_code = dc10.diagnosis_code AND d.diversion_type_id = dc10.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 11
    GROUP BY 1,2,3) AS dc11
  ON d.diagnosis_code = dc11.diagnosis_code AND d.diversion_type_id = dc11.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 12
    GROUP BY 1,2,3) AS dc12
  ON d.diagnosis_code = dc12.diagnosis_code AND d.diversion_type_id = dc12.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 13
    GROUP BY 1,2,3) AS dc13
  ON d.diagnosis_code = dc13.diagnosis_code AND d.diversion_type_id = dc13.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 14
    GROUP BY 1,2,3) AS dc14
  ON d.diagnosis_code = dc14.diagnosis_code AND d.diversion_type_id = dc14.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 15
    GROUP BY 1,2,3) AS dc15
  ON d.diagnosis_code = dc15.diagnosis_code AND d.diversion_type_id = dc15.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 16
    GROUP BY 1,2,3) AS dc16
  ON d.diagnosis_code = dc16.diagnosis_code AND d.diversion_type_id = dc16.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 17
    GROUP BY 1,2,3) AS dc17
  ON d.diagnosis_code = dc17.diagnosis_code AND d.diversion_type_id = dc17.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 18
    GROUP BY 1,2,3) AS dc18
  ON d.diagnosis_code = dc18.diagnosis_code AND d.diversion_type_id = dc18.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 19
    GROUP BY 1,2,3) AS dc19
  ON d.diagnosis_code = dc19.diagnosis_code AND d.diversion_type_id = dc19.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 20
    GROUP BY 1,2,3) AS dc20
  ON d.diagnosis_code = dc20.diagnosis_code AND d.diversion_type_id = dc20.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 21
    GROUP BY 1,2,3) AS dc21
  ON d.diagnosis_code = dc21.diagnosis_code AND d.diversion_type_id = dc21.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 22
    GROUP BY 1,2,3) AS dc22
  ON d.diagnosis_code = dc22.diagnosis_code AND d.diversion_type_id = dc22.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 23
    GROUP BY 1,2,3) AS dc23
  ON d.diagnosis_code = dc23.diagnosis_code AND d.diversion_type_id = dc23.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 24
    GROUP BY 1,2,3) AS dc24
  ON d.diagnosis_code = dc24.diagnosis_code AND d.diversion_type_id = dc24.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 25
    GROUP BY 1,2,3) AS dc25
  ON d.diagnosis_code = dc25.diagnosis_code AND d.diversion_type_id = dc25.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 26
    GROUP BY 1,2,3) AS dc26
  ON d.diagnosis_code = dc26.diagnosis_code AND d.diversion_type_id = dc26.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 27
    GROUP BY 1,2,3) AS dc27
  ON d.diagnosis_code = dc27.diagnosis_code AND d.diversion_type_id = dc27.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 28
    GROUP BY 1,2,3) AS dc28
  ON d.diagnosis_code = dc28.diagnosis_code AND d.diversion_type_id = dc28.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 29
    GROUP BY 1,2,3) AS dc29
  ON d.diagnosis_code = dc29.diagnosis_code AND d.diversion_type_id = dc29.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 30
    GROUP BY 1,2,3) AS dc30
  ON d.diagnosis_code = dc30.diagnosis_code AND d.diversion_type_id = dc30.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 31
    GROUP BY 1,2,3) AS dc31
  ON d.diagnosis_code = dc31.diagnosis_code AND d.diversion_type_id = dc31.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 32
    GROUP BY 1,2,3) AS dc32
  ON d.diagnosis_code = dc32.diagnosis_code AND d.diversion_type_id = dc32.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 33
    GROUP BY 1,2,3) AS dc33
  ON d.diagnosis_code = dc33.diagnosis_code AND d.diversion_type_id = dc33.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 34
    GROUP BY 1,2,3) AS dc34
  ON d.diagnosis_code = dc34.diagnosis_code AND d.diversion_type_id = dc34.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 35
    GROUP BY 1,2,3) AS dc35
  ON d.diagnosis_code = dc35.diagnosis_code AND d.diversion_type_id = dc35.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 36
    GROUP BY 1,2,3) AS dc36
  ON d.diagnosis_code = dc36.diagnosis_code AND d.diversion_type_id = dc36.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 37
    GROUP BY 1,2,3) AS dc37
  ON d.diagnosis_code = dc37.diagnosis_code AND d.diversion_type_id = dc37.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 38
    GROUP BY 1,2,3) AS dc38
  ON d.diagnosis_code = dc38.diagnosis_code AND d.diversion_type_id = dc38.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 39
    GROUP BY 1,2,3) AS dc39
  ON d.diagnosis_code = dc39.diagnosis_code AND d.diversion_type_id = dc39.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 40
    GROUP BY 1,2,3) AS dc40
  ON d.diagnosis_code = dc40.diagnosis_code AND d.diversion_type_id = dc40.diversion_type_id
  JOIN (
    SELECT DISTINCT
      diagnosis_code,
      diversion_type_id,
      CASE WHEN diversion THEN 1 ELSE 0 END AS diversion
    FROM looker_scratch.diversion
    WHERE diversion_category_id = 41
    GROUP BY 1,2,3) AS dc41
  ON d.diagnosis_code = dc41.diagnosis_code AND d.diversion_type_id = dc41.diversion_type_id
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,
           35,36,37,38,39,40,41,42,43
  ORDER BY 1,2 ;;

    sql_trigger_value: SELECT MAX(created_at) FROM looker_scratch.diversion ;;
    indexes: ["diagnosis_code", "diversion_type_id"]
  }

  dimension: compound_primary_key {
    type: string
    hidden: yes
    primary_key: yes
    sql: CONCAT(${diagnosis_code}, ${diversion_type_id}) ;;
  }

  dimension: diagnosis_code {
    type: string
    sql: ${TABLE}.diagnosis_code ;;
  }

  dimension: diversion_type_id {
    type: number
    sql: ${TABLE}.diversion_type_id ;;
  }

  dimension: dc1 {
    type: number
    sql: ${TABLE}.dc1 ;;
  }
  dimension: dc2 {
    type: number
    sql: ${TABLE}.dc2 ;;
  }
  dimension: dc3 {
    type: number
    sql: ${TABLE}.dc3 ;;
  }
  dimension: dc4 {
    type: number
    sql: ${TABLE}.dc4 ;;
  }
  dimension: dc5 {
    type: number
    sql: ${TABLE}.dc5 ;;
  }
  dimension: dc6 {
    type: number
    sql: ${TABLE}.dc6 ;;
  }
  dimension: dc7 {
    type: number
    sql: ${TABLE}.dc7 ;;
  }
  dimension: dc8 {
    type: number
    sql: ${TABLE}.dc8 ;;
  }
  dimension: dc9 {
    type: number
    sql: ${TABLE}.dc9 ;;
  }
  dimension: dc10 {
    type: number
    sql: ${TABLE}.dc10 ;;
  }
  dimension: dc11 {
    type: number
    sql: ${TABLE}.dc11 ;;
  }
  dimension: dc12 {
    type: number
    sql: ${TABLE}.dc12 ;;
  }
  dimension: dc13 {
    type: number
    sql: ${TABLE}.dc13 ;;
  }
  dimension: dc14 {
    type: number
    sql: ${TABLE}.dc14 ;;
  }
  dimension: dc15 {
    type: number
    sql: ${TABLE}.dc15 ;;
  }
  dimension: dc16 {
    type: number
    sql: ${TABLE}.dc16 ;;
  }
  dimension: dc17 {
    type: number
    sql: ${TABLE}.dc17 ;;
  }
  dimension: dc18 {
    type: number
    sql: ${TABLE}.dc18 ;;
  }
  dimension: dc19 {
    type: number
    sql: ${TABLE}.dc19 ;;
  }
  dimension: dc20 {
    type: number
    sql: ${TABLE}.dc20 ;;
  }
  dimension: dc21 {
    type: number
    sql: ${TABLE}.dc21 ;;
  }
  dimension: dc22 {
    type: number
    sql: ${TABLE}.dc22 ;;
  }
  dimension: dc23 {
    type: number
    sql: ${TABLE}.dc23 ;;
  }
  dimension: dc24 {
    type: number
    sql: ${TABLE}.dc24 ;;
  }
  dimension: dc25 {
    type: number
    sql: ${TABLE}.dc25 ;;
  }
  dimension: dc26 {
    type: number
    sql: ${TABLE}.dc26 ;;
  }
  dimension: dc27 {
    type: number
    sql: ${TABLE}.dc27 ;;
  }
  dimension: dc28 {
    type: number
    sql: ${TABLE}.dc28 ;;
  }
  dimension: dc29 {
    type: number
    sql: ${TABLE}.dc29 ;;
  }
  dimension: dc30 {
    type: number
    sql: ${TABLE}.dc30 ;;
  }
  dimension: dc31 {
    type: number
    sql: ${TABLE}.dc31 ;;
  }
  dimension: dc32 {
    type: number
    sql: ${TABLE}.dc32 ;;
  }
  dimension: dc33 {
    type: number
    sql: ${TABLE}.dc33 ;;
  }
  dimension: dc34 {
    type: number
    sql: ${TABLE}.dc34 ;;
  }
  dimension: dc35 {
    type: number
    sql: ${TABLE}.dc35 ;;
  }
  dimension: dc36 {
    type: number
    sql: ${TABLE}.dc36 ;;
  }
  dimension: dc37 {
    type: number
    sql: ${TABLE}.dc37 ;;
  }
  dimension: dc38 {
    type: number
    sql: ${TABLE}.dc38 ;;
  }
  dimension: dc39 {
    type: number
    sql: ${TABLE}.dc39 ;;
  }
  dimension: dc40 {
    type: number
    sql: ${TABLE}.dc40 ;;
  }
  dimension: dc41 {
    type: number
    sql: ${TABLE}.dc41 ;;
  }

}
