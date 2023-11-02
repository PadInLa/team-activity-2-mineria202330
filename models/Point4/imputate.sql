{{ config(materialized='table') }}

SELECT * EXCEPT(Precio, median), IFNULL(Precio, median) AS Precio
FROM {{ source("supermarket", "Olimpica") }}, {{ ref("median")}}