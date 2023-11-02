{{ config(materialized='table') }}

WITH Olimpica_Prices AS (
    SELECT Precio
    FROM {{ source("supermarket", "Olimpica") }}
    WHERE Precio IS NOT NULL
),

Ranked_Prices AS (
    SELECT 
        Precio,
        COUNT(*) OVER() AS total_count,
        ROW_NUMBER() OVER(ORDER BY Precio) AS rn_asc,
        ROW_NUMBER() OVER(ORDER BY Precio DESC) AS rn_desc
    FROM Olimpica_Prices
),

Median_Price AS (
    SELECT 
        AVG(Precio) AS median
    FROM Ranked_Prices
    WHERE rn_asc BETWEEN total_count/2.0 AND total_count/2.0 + 1
    OR rn_desc BETWEEN total_count/2.0 AND total_count/2.0 + 1
)

-- Creates imputate table with the median of the prices in case of null values
SELECT 
    Olimpica.* EXCEPT(Precio),
    IFNULL(Olimpica.Precio, Median_Price.median) AS Precio
FROM 
    {{ source("supermarket", "Olimpica") }} AS Olimpica
CROSS JOIN 
    Median_Price