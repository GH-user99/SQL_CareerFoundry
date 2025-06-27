SELECT city
FROM (
    SELECT CTY_SUB2.city, COUNT(*) AS cust_count
    FROM customer AS CUST_SUB2
    INNER JOIN address AS ADDR_SUB2 ON CUST_SUB2.address_id = ADDR_SUB2.address_id
    INNER JOIN city AS CTY_SUB2 ON ADDR_SUB2.city_id = CTY_SUB2.city_id
    INNER JOIN country AS CTRY_SUB2 ON CTY_SUB2.country_id = CTRY_SUB2.country_id
    WHERE CTRY_SUB2.country IN (
        SELECT country
        FROM (
            SELECT CTRY_SUB3.country, COUNT(*) AS cust_count
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
    LIMIT 10
) AS top_cities
