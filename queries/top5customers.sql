WITH test_table AS (
  SELECT
    CTRY_TOP.country,
    CTY_TOP.city,
    COUNT(CUST_TOP.customer_id) AS num_of_cust
  FROM payment AS PMNT
  INNER JOIN customer AS CUST_TOP ON PMNT.customer_id = CUST_TOP.customer_id
  INNER JOIN address AS ADDR_TOP ON CUST_TOP.address_id = ADDR_TOP.address_id
  INNER JOIN city AS CTY_TOP ON ADDR_TOP.city_id = CTY_TOP.city_id
  INNER JOIN country AS CTRY_TOP ON CTY_TOP.country_id = CTRY_TOP.country_id
  WHERE CTRY_TOP.country IN (
    SELECT country
    FROM (
      SELECT
        CTRY_SUB1.country,
        COUNT(*) AS cust_count
      FROM customer AS CUST_SUB1
      INNER JOIN address AS ADDR_SUB1 ON CUST_SUB1.address_id = ADDR_SUB1.address_id
      INNER JOIN city AS CTY_SUB1 ON ADDR_SUB1.city_id = CTY_SUB1.city_id
      INNER JOIN country AS CTRY_SUB1 ON CTY_SUB1.country_id = CTRY_SUB1.country_id
      GROUP BY CTRY_SUB1.country
      ORDER BY cust_count DESC
      LIMIT 10
    ) AS top_countries
  )
  AND CTY_TOP.city IN (
    SELECT city
    FROM (
      SELECT
        CTY_SUB2.city,
        COUNT(*) AS cust_count
      FROM customer AS CUST_SUB2
      INNER JOIN address AS ADDR_SUB2 ON CUST_SUB2.address_id = ADDR_SUB2.address_id
      INNER JOIN city AS CTY_SUB2 ON ADDR_SUB2.city_id = CTY_SUB2.city_id
      INNER JOIN country AS CTRY_SUB2 ON CTY_SUB2.country_id = CTRY_SUB2.country_id
      WHERE CTRY_SUB2.country IN (
        SELECT country
        FROM (
          SELECT
            CTRY_SUB3.country,
            COUNT(*) AS cust_count
          FROM customer AS CUST_SUB3
          INNER JOIN address AS ADDR_SUB3 ON CUST_SUB3.address_id = ADDR_SUB3.address_id
          INNER JOIN city AS CTY_SUB3 ON ADDR_SUB3.city_id = CTY_SUB3.city_id
          INNER JOIN country AS CTRY_SUB3 ON CTY_SUB3.country_id = CTRY_SUB3.country_id
          GROUP BY CTRY_SUB3.country
          ORDER BY cust_count DESC
          LIMIT 10
        ) AS top_countries
      )
      GROUP BY CTY_SUB2.city
    ) AS top_cities
  )
  GROUP BY CTY_TOP.city, CTRY_TOP.country
  ORDER BY num_of_cust DESC
  LIMIT 10
)

SELECT
  CUST_MAIN.first_name,
  CUST_MAIN.last_name,
  SUM(PMNT_MAIN.amount) AS total,
  CTY_MAIN.city,
  CTRY_MAIN.country
FROM customer AS CUST_MAIN
INNER JOIN payment AS PMNT_MAIN ON CUST_MAIN.customer_id = PMNT_MAIN.customer_id
INNER JOIN address AS ADDR_MAIN ON CUST_MAIN.address_id = ADDR_MAIN.address_id
INNER JOIN city AS CTY_MAIN ON ADDR_MAIN.city_id = CTY_MAIN.city_id
INNER JOIN country AS CTRY_MAIN ON CTY_MAIN.country_id = CTRY_MAIN.country_id
WHERE (CTRY_MAIN.country, CTY_MAIN.city) IN (
  SELECT country, city FROM test_table
)
GROUP BY
  CUST_MAIN.first_name,
  CUST_MAIN.last_name,
  CTY_MAIN.city,
  CTRY_MAIN.country
ORDER BY total DESC
LIMIT 5;
