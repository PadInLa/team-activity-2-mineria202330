{{ config(materialized='table') }}

-- Query that returns only the bought products from both supermarkets.
SELECT 
  allprod_.*,
  COALESCE(purchases.Frecuencia, 0) AS Frecuencia
FROM 
  (
    SELECT *, 'Exito' AS almacen
    FROM {{ source("supermarket", "Exito") }}

    UNION ALL

    SELECT *, 'Olimpica' AS almacen
    FROM {{ source("supermarket", "imputate") }}
  ) allprod_
LEFT JOIN 
  (
    SELECT producto, COUNT(producto) AS Frecuencia
    FROM {{ source("supermarket", "Compras") }}
    GROUP BY producto
  ) purchases 
ON allprod_.Codigo = purchases.producto
WHERE purchases.Frecuencia IS NOT NULL
ORDER BY 
  Frecuencia DESC
LIMIT 20