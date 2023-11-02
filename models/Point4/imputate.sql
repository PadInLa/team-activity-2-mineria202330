-- Creates imputate table with the median of the prices in case of null values

{{ config(materialized='table') }}

SELECT * EXCEPT(Precio, median), IFNULL(Precio, median) AS Precio
FROM {{ source("supermarket", "Olimpica") }}, {{ ref("median_")}}