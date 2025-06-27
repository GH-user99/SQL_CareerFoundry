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
