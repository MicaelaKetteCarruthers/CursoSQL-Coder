-- Scrip de Funciones
USE online_store;

-- Funcón para saber cuanto se vendió en el día que se pase como parametro
-- (en una situación real se haría con el día actual)

DROP FUNCTION IF EXISTS sales_of_the_day;

DELIMITER $$
CREATE FUNCTION sales_of_the_day(fecha_elegida DATE)
RETURNS FLOAT(8,2)
READS SQL DATA
BEGIN
	-- hago un select con la sumatoria del total vendido de la tabla order_details en la fecha que se pasa como parámetro
	RETURN (SELECT SUM(total)
			FROM order_details
			WHERE order_date = fecha_elegida);
END
$$

SELECT sales_of_the_day('2017-12-16');


-- Funcion que te dice si el envio fue entregado o no con el id de la orden(evito un join):

DELIMITER $$
CREATE FUNCTION delivery_status(order_id INT)
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
	DECLARE shipment_id INT;
    DECLARE d_status BOOLEAN;
    DECLARE outcome VARCHAR(50);
    
    -- primero obtengo el id del envío y lo guardo en una variable
    SET shipment_id = (	SELECT shipping_id 
						FROM order_details 
                        WHERE id = order_id);
                        
	-- después utilizo el id del envío para buscar el status del envio y lo guardo en otra variable
    SET d_status = (SELECT delivery_status
					FROM shipment_details 
                    WHERE id = shipment_id);
                    
    -- por último, con un condicional genero el mensaje que devuelve la función:
    IF d_status = 0 THEN
		SET outcome = 'The order has not been delivered';
	ELSE
		SET outcome = 'The order has been delivered';
	END IF;
	RETURN outcome;
END
$$

SELECT delivery_status(100006);