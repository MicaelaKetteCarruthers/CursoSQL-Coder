-- SCRIPT DE CREACIÓN DE TRIGGERS

/* La primer tabla LOG va a contener datos de eliminación, inserción o updates que se le hagan a la tabla productos.
Para eso, creo la tabla LOG va a tener su id y el del producto, el nombre del producto, que tipo de accion se realizó (inserción, eliminación o actualización),
una descripción con campos importantes o con los cambios que se hayan hecho, la fecha, la hora y el usuario que realizó la acción: */

USE online_store;

CREATE TABLE IF NOT EXISTS log_products (
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    product_name TEXT NOT NULL,
    action VARCHAR(15) NOT NULL,
    description VARCHAR(100) NOT NULL,
    action_date DATE NOT NULL,
    action_hour TIME NOT NULL,
    by_user VARCHAR(20) NOT NULL
);

-- Como triger de tipo Before decidí hacer un trigger cuando se elimine un producto:

DROP TRIGGER IF EXISTS tr_delete_product_log;

DELIMITER $$
CREATE TRIGGER tr_delete_product_log 
BEFORE DELETE ON products
FOR EACH ROW
BEGIN
	INSERT INTO log_products (log_id, product_id, product_name, action, description, action_date, action_hour, by_user)
    VALUES (
			NULL,
            OLD.id,
            OLD.product_name,
            'DELETE',
            CONCAT('sub category id: ', OLD.sub_category_id, ', price: ', OLD.price, ', cost: ', OLD.cost),
            CURDATE(),
            CURTIME(),
            USER()
			);
END
$$

-- Como trigger de tipo after voy a grear un trigger cuando se quiera insertar un nuevo producto:

DROP TRIGGER IF EXISTS tr_insert_product_log;

DELIMITER $$
CREATE TRIGGER tr_insert_product_log 
AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO log_products (log_id, product_id, product_name, action, description, action_date, action_hour, by_user)
    VALUES (
			NULL,
            NEW.id,
            NEW.product_name,
            'INSERT',
            CONCAT('sub category id: ', NEW.sub_category_id, ', price: ', NEW.price, ', cost: ', NEW.cost),
            CURDATE(),
            CURTIME(),
            USER()
			);
END
$$

-- Inserto un dato en la tabla productos para probar el trigger del insert

INSERT INTO products
VALUES (10005002, 'Product B14', 1, 8, 40.00, NULL, 32.00);

-- Elimino el mismo dato para ver si anda el trigger del delete:

DELETE FROM products
WHERE id = 10005002;

SELECT * FROM log_products;

-- --------------------------------------------------------------------------------------------------------------------------------

/*La segunda tabla LOG va a ser para la tabla discounts, va a registrar las actualizaciones que se le hagan a dicha tabla.
Esta tabla va a tener su id, la descripción de la actualización, los cambios antes y después del cambio, el día, la fecha y el usuario que lo realizó*/

CREATE TABLE IF NOT EXISTS log_discounts (
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(100),
    fields_bfr_change VARCHAR(100) NOT NULL,
    fields_aftr_change VARCHAR(100) NOT NULL, 
    change_day DATE NOT NULL,
    change_hour TIME NOT NULL,
    by_user VARCHAR(30) NOT NULL
);


-- El primer trigger es de before, ya que va a chequear que si se hace un cambio en el porcentaje del descuento, y este es mayor al 50%, va a impedir
-- que se lleve a cabo el update dando un mensaje de error, y va a registrar el cambio fallido en la tabla log.

DROP TRIGGER IF EXISTS tr_before_update_discounts;

DELIMITER $$
CREATE TRIGGER tr_before_update_discounts
BEFORE UPDATE ON discounts
FOR EACH ROW
BEGIN
	-- Declaro la variable que va a contener el mensaje de error, y se lo asigno:
    
	DECLARE error_message VARCHAR(100);
    SET error_message = CONCAT('The new percent ',
								NEW.discount_percent,
                                ' cannot be greater than 50%');
                                
	-- Creo el condicional para el caso que el porcentaje se mayor a 0.50, genero el insert en la tabla log e impido el cambio mandando el mensaje:
    
	IF NEW.discount_percent > 0.50 THEN
		INSERT INTO log_discounts (log_id, description, fields_bfr_change, fields_aftr_change, change_day, change_hour, by_user)
        VALUES (NULL,
                'Error : Attempted to make a percentage change to a value greater than 50%',
                'NO CHANGES',
                'NO CHANGES',
                CURDATE(),
                CURTIME(),
                user()
                );
                
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = error_message;
            
	END IF;
END 
$$

-- Prueba del trigger:

UPDATE discounts
SET discount_percent = 0.60
WHERE id = 5;

SELECT * FROM log_discounts;


-- El segundo trigger es de after update, se va a asegurar que el cambio que se realice sea en el porcentaje o en el campo activo, ya que si se genera
-- el cambio en algún otro campo no va a ser de interés. Luego va a guardar tanto los datos viejos como los nuevos en la tabla log.

DROP TRIGGER IF EXISTS tr_after_update_discounts;

DELIMITER $$
CREATE TRIGGER tr_after_update_discounts
AFTER UPDATE ON discounts
FOR EACH ROW
BEGIN
	-- primero genero el condicional que va a chequear que se haga el cambio en los campos de interés:
    
	IF OLD.discount_percent != NEW.discount_percent OR OLD.active != NEW.active THEN
    
    -- luego se genera el insert en la tabla log:
    
		INSERT INTO log_discounts (log_id, description, fields_bfr_change, fields_aftr_change, change_day, change_hour, by_user)
        VALUES (NULL,
                CONCAT('An update was successfully performed on the id discount: ', OLD.id),
                CONCAT('percent: ', OLD.discount_percent, ', active: ', OLD.active),
                CONCAT('percent: ', NEW.discount_percent, ', active: ', NEW.active),
                CURDATE(),
                CURTIME(),
                user()
                );
	END IF;
END 
$$


-- Prueba del trigger:

INSERT INTO discounts 
VALUES (NULL, 'Discount Pepito', 0.05, 0);

UPDATE discounts
SET active = 1
WHERE discount_name = 'Discount Pepito';

SELECT * FROM log_discounts;

DELETE FROM discounts
WHERE discount_name = 'Discount Pepito';