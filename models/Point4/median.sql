SELECT
CASE
WHEN MOD(cantidad, 2)=0 THEN (SELECT AVG(Precio) FROM {{ ref("add_row_id") }} WHERE row_id BETWEEN cantidad/2 AND cantidad/2+1)
ELSE (SELECT Precio FROM {{ ref("add_row_id") }} WHERE row_id=ROUND(cantidad/2))
END median
FROM {{ ref("add_row_id") }}
LIMIT 1