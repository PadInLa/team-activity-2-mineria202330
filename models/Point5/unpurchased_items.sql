{{ config(materialized='table') }}

-- Query that returns the products that were not bought from both supermarkets.
SELECT *, 'Olimpica' AS almacen
FROM {{ source("supermarket", "imputate") }} AS Olimpica
WHERE NOT EXISTS (
  SELECT 1
  FROM {{ source("supermarket", "Compras") }}
  WHERE producto = Olimpica.Codigo
)

UNION ALL

SELECT *, 'Exito' AS almacen
FROM {{ source("supermarket", "Exito") }} AS Exito
WHERE NOT EXISTS (
  SELECT 1
  FROM {{ source("supermarket", "Compras") }}
  WHERE producto = Exito.Codigo
)