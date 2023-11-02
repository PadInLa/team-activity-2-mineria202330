{{ config(materialized='table') }}

-- Query that returns the unique buyers of the Olimpica supermarket with Left Join to check for the existence of the EXI product in the purchase table.
SELECT DISTINCT client.*
FROM {{ source("supermarket", "Clientes") }} client
LEFT JOIN {{ source("supermarket", "Compras") }} compra_
ON client.C__digo = compra_.cliente AND compra_.producto LIKE 'EXI%'
WHERE compra_.cliente IS NULL