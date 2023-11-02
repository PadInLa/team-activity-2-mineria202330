SELECT Precio, COUNT(*) OVER() AS cantidad
FROM {{ source("supermarket", "Olimpica") }}
WHERE Precio IS NOT NULL
ORDER BY Precio