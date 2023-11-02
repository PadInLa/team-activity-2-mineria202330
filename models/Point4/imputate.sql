{{ config(materialized='table') }}

SELECT * EXCEPT(Precio, median), IF NULL(Precio, median) AS Precio
FROM {{ source("supermarket", "Olimpica") }}, {{ ref("median_")}}