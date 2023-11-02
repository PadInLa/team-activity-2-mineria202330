{{ config(materialized='table') }}

WITH mean_price AS (
    -- Total number of non-null Precio entries.
    SELECT Precio, COUNT(*) OVER() AS cantidad
    FROM {{ source("supermarket", "Olimpica") }}
    WHERE Precio IS NOT NULL
    ORDER BY Precio
),

add_row_id AS (
    -- Selects all fields from model mean_price and assign a unique row number to each row.
    SELECT *, ROW_NUMBER() OVER () AS row_id
    FROM mean_price
)

median_ AS (
    -- Calculates the median of the prices of the products in the table depending if the number of rows is even or odd.
    SELECT
    CASE
    WHEN MOD(cantidad, 2)=0 THEN (SELECT AVG(Precio) FROM add_row_id WHERE row_id BETWEEN cantidad/2 AND cantidad/2+1)
    ELSE (SELECT Precio FROM add_row_id WHERE row_id=ROUND(cantidad/2))
    END median
    FROM add_row_id
    LIMIT 1
)

-- Creates imputate table with the median of the prices in case of null values
SELECT * EXCEPT(Precio, median), IFNULL(Precio, median) AS Precio
FROM {{ source("supermarket", "Olimpica") }}, median_
