{{ config(materialized='table') }}

WITH Olimpica_Buyers AS (
  SELECT DISTINCT client.C__digo
  FROM {{ source("supermarket", "Clientes") }} client
  INNER JOIN {{ source("supermarket", "Compras") }} compra_
  ON client.C__digo = compra_.cliente
  WHERE compra_.producto LIKE 'OLI%'
),

Exito_Buyers AS (
  SELECT DISTINCT compra_.cliente
  FROM {{ source("supermarket", "Compras") }} compra_
  WHERE compra_.producto LIKE 'EXI%'
)

-- Query that returns unique buyers from Olimpica who have not bought from Exito.
SELECT client.*
FROM Olimpica_Buyers olimpica_client
LEFT JOIN Exito_Buyers exito_client
ON olimpica_client.C__digo = exito_client.cliente
INNER JOIN {{ source("supermarket", "Clientes") }} client
ON olimpica_client.C__digo = client.C__digo
WHERE exito_client.cliente IS NULL