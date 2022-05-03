-- CREACIÓN DE VISTAS:

USE online_store;

-- Cantidad de ordenes y ventas por estado:

CREATE OR REPLACE VIEW vw_sales_by_state
AS (
	SELECT s.state, 
			COUNT(o.id) AS orders_quantity, 
			AVG(s.shipping_cost) AS avg_shipping_cost, 
			SUM(o.total) AS total_sold
	FROM order_details o
		LEFT JOIN shipment_details s
		ON o.shipping_id = s.id
	GROUP BY s.state
	ORDER BY orders_quantity DESC, total_sold DESC);
    
    
-- Cantidad de ordenes y ventas por usuario:

CREATE OR REPLACE VIEW vw_sales_by_user
AS	
(SELECT CONCAT(u.first_name, ' ', u.last_name) AS user_name, 
		u.email AS user_email, 
		u.phone_number AS user_phone_number,
		u.segment AS user_segment,
		SUM(o.total) AS total_sold,
		COUNT(o.id) AS orders_quantity 
FROM order_details o 
	LEFT JOIN user u
	ON o.user_id = u.id
GROUP BY user_name, user_email, user_phone_number
ORDER BY total_sold DESC, orders_quantity DESC);


--  Productos más vendidos:

CREATE OR REPLACE VIEW vw_products_sale
AS 
	(SELECT p.product_name AS product_name, 
			s.sub_category_name AS sub_category,
			(o.quantity * p.price) AS total_sold,
			SUM(o.quantity) AS quantity_sold 
	FROM products p
		RIGHT JOIN order_product o ON p.id = o.product_id  
		LEFT JOIN sub_categories s ON p.sub_category_id = s.id
	GROUP BY product_name, sub_category
	ORDER BY total_sold DESC, quantity_sold DESC);
    

-- Top 10 provedores de tarjetas de credito más utilizados:

CREATE OR REPLACE VIEW vw_credit_card_provider_top
AS 
	(SELECT provider, 
			COUNT(*) AS amount_used, 
			SUM(amount) AS total_sold
	FROM payment_details 
	GROUP BY provider
	ORDER BY total_sold DESC, amount_used DESC
	LIMIT 10);
    

-- Órdenes hechas en 2017 que fueron pagadas en cuotas:

CREATE OR REPLACE VIEW vw_installement_orders_2017
AS
	(SELECT o.order_date AS order_date,
			CONCAT(u.first_name, ' ', u.last_name) AS user_name,
			p.amount AS amount,
			p.payment_installements
	FROM order_details o
		LEFT JOIN user u ON o.user_id = u.id
		LEFT JOIN payment_details p ON o.payment_id = p.id
	WHERE 	o.order_date >= '2017-01-01' 
			AND p.payment_installements > 1 
	ORDER BY order_date);
    
    