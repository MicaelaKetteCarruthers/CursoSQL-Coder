-- SCRIPT DE TRANSACCIONES:

USE online_store;

SELECT @@AUTOCOMMIT;
SET @@AUTOCOMMIT = 0;


-- Primera transaccion: elimino de la tabla discounts aquellos descuentos que sean mayores al 50 %. Como no tengo ninguno primero lo inserto.

START TRANSACTION;

INSERT INTO discounts (id, discount_name, discount_percent, active)
VALUES (NULL, 'Exaple discount', 0.6, 0);

SELECT * FROM discounts ORDER BY discount_percent DESC;

DELETE FROM discounts
WHERE discount_percent > 0.5;

SELECT * FROM discounts ORDER BY discount_percent DESC;

-- ROLLBACK;
-- COMMIT; 

-- Segunda transacción: Insertar datos en lotes de 4 productos en la tabla products 

START TRANSACTION;

INSERT INTO products (id, product_name, category_id, sub_category_id, price, discount_id, cost)
VALUES (10005001, 'Lifeprint Portable Photo and Video Printer- White', 3, 16, 129.99, NULL, 76.46);
INSERT INTO products (id, product_name, category_id, sub_category_id, price, discount_id, cost)
VALUES (10005002, 'HP 410A Black Toner Cartridge', 2, 15, 36.29, NULL, 21.35);
INSERT INTO products (id, product_name, category_id, sub_category_id, price, discount_id, cost)
VALUES (10005003, 'CASEMATIX Printer Travel Case', 3, 10, 67.97, NULL, 39.98);
INSERT INTO products (id, product_name, category_id, sub_category_id, price, discount_id, cost)
VALUES (10005004, 'Redi-Tag Divider Sticky Notes, 60 Ruled Notes', 2, 11, 11.48, NULL, 6.75);

SAVEPOINT batch_1;

INSERT INTO products (id, product_name, category_id, sub_category_id, price, discount_id, cost)
VALUES (10005005, 'Mead Spiral Notebooks, College Ruled Paper, 70 Sheets, 6 pack', 2, 12, 21.79, NULL, 12.82);
INSERT INTO products (id, product_name, category_id, sub_category_id, price, discount_id, cost)
VALUES (10005006, 'Classic Puresoft Padded Mid-Back Office Computer Desk Chair with Armrest - Black', 1, 2, 94.86, NULL, 55.80);
INSERT INTO products (id, product_name, category_id, sub_category_id, price, discount_id, cost)
VALUES (10005007, 'Furinno Luder Bookcase / Book / Storage , 5-Cube, White', 1, 11, 79.99, NULL, 47.05);
INSERT INTO products (id, product_name, category_id, sub_category_id, price, discount_id, cost)
VALUES (10005008, 'Mesh Desk Organizer with Sliding Drawer, Double Tray and 5 Upright Sections, Black', 2, 3, 27.20, NULL, 16.00);

SAVEPOINT batch_2;

SELECT * FROM products ORDER BY id DESC;

-- ROLLBACK;
-- ROLLBACK TO batch_1; 
-- RELEASE SAVEPOINT batch_1;
-- COMMIT;

