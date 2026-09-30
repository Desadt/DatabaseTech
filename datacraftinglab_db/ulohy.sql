-- Active: 1790168926319@@127.0.0.1@5432@datacraftinglab

--uloha1
SELECT product_name, total_amount
FROM flourmills_sales
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
);