DROP SCHEMA IF EXISTS online_store;
CREATE SCHEMA IF NOT EXISTS online_store;  

USE online_store;

CREATE TABLE IF NOT EXISTS categories (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(15) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS sub_categories (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    sub_category_name VARCHAR(15) NOT NULL
) ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS products (
	id INT PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id SMALLINT,
    sub_category_id SMALLINT,
    price FLOAT(8,2) NOT NULL,
    discount_id SMALLINT,
    cost FLOAT(8,2) NOT NULL 
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS discounts (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    discount_name VARCHAR(15),
    discount_percent FLOAT(3,2) NOT NULL,
    active BOOLEAN NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS user (
	id INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    password VARCHAR(20) NOT NULL UNIQUE,
    segment VARCHAR(20) DEFAULT 'Consumer',
    email VARCHAR(50) NOT NULL UNIQUE,
    phone_number VARCHAR(12) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS user_payment (
	id SMALLINT PRIMARY KEY,
    user_id INT NOT NULL,
    provider VARCHAR(30) NOT NULL,
    card_number VARCHAR(20) NOT NULL,
    expiry DATE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS user_addresses (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address VARCHAR(30) NOT NULL,
    country VARCHAR(20) NOT NULL,
    state VARCHAR(20) NOT NULL,
    postal_code INT NOT NULL,
    region VARCHAR(20)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS order_product (
	order_id INT,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id,product_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS order_details (
	id INT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATE NOT NULL,
    total FLOAT(8,2) NOT NULL
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS shipment_details (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    ship_date DATE,
    ship_mode VARCHAR(20) NOT NULL,
    postal_code INT NOT NULL,
    state VARCHAR(20) NOT NULL,
    shipping_cost FLOAT(4,2) NOT NULL,
    delivery_status BOOLEAN
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS payment_details (
	id SMALLINT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    amount FLOAT(8,2)NOT NULL,
    provider VARCHAR(30) NOT NULL,
    payment_installements SMALLINT NOT NULL
) ENGINE = InnoDB;

ALTER TABLE products
	ADD CONSTRAINT fk_products_category
    FOREIGN KEY (category_id)
    REFERENCES categories(id)
    ON UPDATE CASCADE;
    
ALTER TABLE products
	ADD CONSTRAINT fk_products_sub_category
    FOREIGN KEY (sub_category_id)
    REFERENCES sub_categories(id)
    ON UPDATE CASCADE;
    
ALTER TABLE products
	ADD CONSTRAINT fk_products_discounts 
    FOREIGN KEY (discount_id)
    REFERENCES discounts(id)
    ON UPDATE CASCADE;
    
ALTER TABLE user_payment
	ADD CONSTRAINT fk_user_payment_user 
    FOREIGN KEY (user_id)
    REFERENCES user(id)
    ON UPDATE CASCADE;
    
ALTER TABLE user_addresses
	ADD CONSTRAINT fk_user_addresses_user
    FOREIGN KEY (user_id)
    REFERENCES user(id)
    ON UPDATE CASCADE;
    
ALTER TABLE order_product
	ADD CONSTRAINT fk_order_product_order_details
    FOREIGN KEY (order_id)
    REFERENCES order_details(id)
    ON UPDATE CASCADE;
    
ALTER TABLE order_product
	ADD CONSTRAINT fk_order_product_products
    FOREIGN KEY (product_id)
    REFERENCES products(id)
    ON UPDATE CASCADE;
    
ALTER TABLE order_details
	ADD CONSTRAINT fk_order_details_user
    FOREIGN KEY (user_id)
    REFERENCES user(id)
    ON UPDATE CASCADE;
    
ALTER TABLE shipment_details
	ADD CONSTRAINT fk_shipment_order_details
    FOREIGN KEY (order_id)
    REFERENCES order_details(id)
    ON UPDATE CASCADE;
    
ALTER TABLE payment_details
	ADD CONSTRAINT fk_payment_order_details
    FOREIGN KEY (order_id)
    REFERENCES order_details(id)
    ON UPDATE CASCADE;
    