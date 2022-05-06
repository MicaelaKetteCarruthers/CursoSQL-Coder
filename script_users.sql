-- SCRIPT DE CREACIÓN DE USUARIOS


-- Creación de usuario de solo lectura: 

CREATE USER 'user_type_1'@'localhost' IDENTIFIED BY 'only_lecture';

-- Verificación de su creación: 

SELECT * FROM mysql.user WHERE user LIKE 'user_type_1%';

-- Conseder permisos a user_type_1

GRANT SELECT ON online_store.* TO 'user_type_1'@'localhost';

-- Verificación de los permisos concedidos a user_type_1

SHOW GRANTS FOR 'user_type_1'@'localhost';

-- -----------------------------------------------------------------------------------------------

-- Creación de usuario de lectura, modificación e inserción: 

CREATE USER 'user_type_2'@'localhost' IDENTIFIED BY 'lect_mod_ins';

-- Verificación de su creación: 

SELECT * FROM mysql.user WHERE user LIKE 'user_type_2%';

-- Conseder permisos a user_type_2

GRANT SELECT, UPDATE, INSERT ON online_store.* TO 'user_type_2'@'localhost';

-- Verificación de los permisos concedidos a user_type_2

SHOW GRANTS FOR 'user_type_2'@'localhost';
