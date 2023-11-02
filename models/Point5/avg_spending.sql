{{ config(materialized='table') }}

-- CTE that aggregates the number of purchases per product
WITH Compras_Aggregated as (
  SELECT producto, COUNT(*) AS cantidad
  FROM {{  source("supermarket", "Compras")}}
  GROUP BY producto
),

-- CTE that selects the products that are Vino Tinto from both supermarkets.
Vinotinto_Prod AS (
    SELECT Codigo, Precio
    FROM {{ source("supermarket", "Exito") }}
    WHERE Producto LIKE '%Vino Tinto%'

    UNION ALL

    SELECT Codigo, Precio
    FROM {{ source("supermarket", "imputate") }}
    WHERE Producto LIKE '%Vino Tinto%'
)

-- Main query that calculates the average spending per product in each supermarket
SELECT 
  almacen,
  producto,
  cantidad,
  total,
  (SUM(total) OVER (PARTITION BY almacen)) / (SUM(cantidad) OVER (PARTITION BY almacen)) AS promedio_almacen
FROM (
    SELECT 
      IF(SUBSTR(vino_tinto_.Codigo, 1, 3) = 'OLI', 'Olimpica', 'EXITO') AS almacen,
      vino_tinto_.Codigo AS producto, 
      compras_.cantidad,
      compras_.cantidad * vino_tinto_.Precio AS total
    FROM Compras_Aggregated compras_
    INNER JOIN Vinotinto_Prod vino_tinto_ 
    ON compras_.producto = vino_tinto_.Codigo
) por_almacen