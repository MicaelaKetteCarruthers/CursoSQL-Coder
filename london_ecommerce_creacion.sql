DROP SCHEMA IF EXISTS london_ecommerce;
CREATE SCHEMA IF NOT EXISTS london_ecommerce;  

USE london_ecommerce;

CREATE TABLE IF NOT EXISTS retail_customer (
	ret_customer_id INT PRIMARY KEY,
	name VARCHAR(25),
	last_name VARCHAR(25),
	email VARCHAR(25)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS wholesale_customer (
	whole_customer_id INT PRIMARY KEY,
	tax_identification INT,
	name VARCHAR(25),
	email VARCHAR(25)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS product (
	product_id VARCHAR(10) PRIMARY KEY,
	name VARCHAR(25),
	price FLOAT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS delivery_details (
	delivery_id INT AUTO_INCREMENT PRIMARY KEY,
	country VARCHAR(25),
	address VARCHAR(25),
	postal_code VARCHAR(25),
	price FLOAT
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS payment_details (
	payment_id INT AUTO_INCREMENT PRIMARY KEY,
	payment_type VARCHAR(25),
	amount FLOAT,
	provider VARCHAR(25)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS order_details (
	order_id VARCHAR(10) PRIMARY KEY,
	ret_customer_id INT,
	whole_customer_id INT,
	payment_id INT,
	delivery_id INT,
	total FLOAT,
	order_date DATETIME
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS order_product (
	order_id VARCHAR(10),
	product_id VARCHAR(10),
	quantity INT,
	PRIMARY KEY (order_id, product_id)
) ENGINE = InnoDB;

ALTER TABLE order_details
	ADD FOREIGN KEY (ret_customer_id)
    REFERENCES retail_customer(ret_customer_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
    
ALTER TABLE order_details
	ADD FOREIGN KEY (whole_customer_id)
    REFERENCES wholesale_customer(whole_customer_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
    
ALTER TABLE order_details
	ADD FOREIGN KEY (payment_id)
    REFERENCES payment_details(payment_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE order_details
	ADD FOREIGN KEY (delivery_id)
    REFERENCES delivery_details(delivery_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
    
ALTER TABLE order_product
	ADD FOREIGN KEY (order_id)
    REFERENCES order_details(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

ALTER TABLE order_product
	ADD FOREIGN KEY (product_id)
    REFERENCES product(product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;