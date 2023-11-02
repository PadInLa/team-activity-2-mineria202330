-- Selects all fields from model mean_price and assign a unique row number to each row.
SELECT *, ROW_NUMBER() OVER () AS row_id
FROM {{ ref("mean_price") }}