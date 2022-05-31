-- CREACIÓN DE STORED PROCEDURE

USE online_store;

-- Stored Procedure que ordena la tabla order_details por el parámetro elegido:

DROP PROCEDURE IF EXISTS sp_order_order_details;

DELIMITER $$
CREATE PROCEDURE sp_order_order_details(IN sort_field VARCHAR(20), IN type_of_order VARCHAR(5))
BEGIN
	/* Primero creo una variable con el primer parámetro, el cual va a servir para ver por que campo se ordena la query.
    Genero un condicional para elegir el campo id como predeterminado en caso de que pasen el parámetro en blanco*/
	IF sort_field != '' THEN
		SET @sql_order = sort_field;
	ELSE
		SET @sql_order = 'id';
	END IF;
    
    -- Luego genero una variable con el segundo parametro y lo paso a mayusculas por conveniencia
    SET @order_type = UPPER(type_of_order);
    
    /*Genero otro condicional en donde si mi seguna variable es desc o asc me genere la query, y si no
    que me genere un mensaje de error diciendole al usuario que inserte el parámetro correcto*/
    
    IF @order_type = 'DESC' OR @order_type = 'ASC' THEN
		SET @expression = CONCAT('SELECT * FROM order_details ORDER BY ', @sql_order,' ', @order_type);
        
        PREPARE ordered_query FROM @expression;
		EXECUTE ordered_query;
		DEALLOCATE PREPARE ordered_query;
	ELSE 
		SELECT 'Error: could not sort, please enter a correct type_of_order' AS 'Error' FROM dual;
	END IF;
     
END
$$

CALL sp_order_order_details('order_date','desc');
CALL sp_order_order_details('','');


-- Stored procedure que inserta datos en la tabla discounts:

DROP PROCEDURE IF EXISTS sp_insert_in_discounts;

DELIMITER $$
CREATE PROCEDURE sp_insert_in_discounts(IN discount_name VARCHAR(15), IN discount_percent DEC(3,2))
BEGIN
	-- Primero guardo los parametros en variables
    SET @name = discount_name;
    SET @percent = discount_percent;
    
    /*Despues, dada la condicion de que el porcentaje de descuento tiene que estar entre 0 y 1 hago un condicional. Si se cumple,
	hago otro condicional en donde si el parametro discount_name no es vacio hago el insert con los dos parametros, y si es vacio en su 
    lugar pongo null*/
    IF @percent < 1 AND @percent > 0 THEN
		IF @name != '' THEN
			INSERT INTO online_store.discounts (discount_name, discount_percent, active)
            VALUES (@name, @percent, 1);
		ELSE
			INSERT INTO online_store.discounts (discount_name, discount_percent, active)
            VALUES (NULL, @percent, 1);
		END IF;
		-- hago un select para ver eldato insertado en la tabla
        SELECT * FROM discounts ORDER BY id DESC;
	-- si el pocentaje que me pasan como parametro no está dentro del rango se muestra el siguiente mensaje de error:
	ELSE 
		SELECT 'Error: The insert was not carried out, please enter a correct discount_percent' AS 'ERROR' FROM dual;
        
	END IF;
END
$$

CALL sp_insert_in_discounts('Christmas', 0.05);
CALL sp_insert_in_discounts('',0.07);
CALL sp_insert_in_discounts('Christmas', 1.1);

DELETE FROM discounts 
WHERE id IN (7,8);
