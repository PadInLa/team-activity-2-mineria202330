{{ config(materialized='table') }}

-- CTE that gets the top clients from Exito and Olimpica.
WITH top_clients AS (
    -- Select top clients from Exito
    SELECT compra_.cliente AS cod_client, COUNT(compra_.cliente) AS comprasTotales, 'Exito' AS almacen
    FROM {{ source("supermarket", "Compras") }} compra_
    INNER JOIN {{ source("supermarket", "Exito") }} exito_ 
    ON compra_.producto = exito_.Codigo
    GROUP BY compra_.cliente

    UNION ALL

    -- Select top clients from Olimpica
    SELECT compra_.cliente AS cod_client, COUNT(compra_.cliente) AS comprasTotales, 'Olimpica' AS almacen
    FROM {{ source("supermarket", "Compras") }} compra_
    INNER JOIN {{ source("supermarket", "imputate") }} olimpica_ 
    ON compra_.producto = olimpica_.Codigo
    GROUP BY compra_.cliente
)
-- Order the results by comprasTotales in descending order after the union operation
SELECT promPurchasers_.*, clientes_.*
FROM top_clients promPurchasers_
INNER JOIN {{ source("supermarket", "Clientes") }} clientes_
ON promPurchasers_.cod_client = clientes_.C__digo
ORDER BY comprasTotales DESC


