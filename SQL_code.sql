CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(2)
);

CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id, product_id)
);

CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10, 8),
    geolocation_lng DECIMAL(11, 8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
);

-- DATA RETRIEVAL

SELECT * 
FROM customers;


SELECT customer_id, customer_city, customer_state 
FROM customers;


SELECT * 
FROM customers 
LIMIT 10;


SELECT * 
FROM orders;


-- INSERT, UPDATE, DELETE


INSERT INTO customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
VALUES ('test_customer_001', 'test_unique_001', '01310', 'sao paulo', 'SP');


INSERT INTO customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
VALUES 
    ('test_customer_002', 'test_unique_002', '22041', 'rio de janeiro', 'RJ'),
    ('test_customer_003', 'test_unique_003', '30130', 'belo horizonte', 'MG');

INSERT INTO products (product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty)
VALUES ('test_product_001', 'electronics', 50, 200, 3);

UPDATE customers 
SET customer_city = 'campinas' 
WHERE customer_id = 'test_customer_001';

UPDATE customers 
SET customer_city = 'santos', customer_state = 'SP' 
WHERE customer_id = 'test_customer_002';

DELETE FROM customers 
WHERE customer_id = 'test_customer_003';

DELETE FROM orders 
WHERE order_status = 'cancelled';

-- WHERE

SELECT * 
FROM customers 
WHERE customer_city = 'sao paulo';

SELECT * 
FROM orders 
WHERE order_status = 'delivered';

SELECT * 
FROM products 
WHERE product_weight_g >= 1000;

SELECT * 
FROM payments 
WHERE payment_value BETWEEN 50 AND 200;

SELECT * 
FROM customers 
WHERE customer_state IN ('SP', 'RJ', 'MG');

-- Show data where the customer state is SP and city is Sao paulo
SELECT * 
FROM customers 
WHERE customer_state = 'SP' AND customer_city = 'sao paulo';

-- Show orders which are delivered or shipped
SELECT * 
FROM orders 
WHERE order_status = 'delivered' OR order_status = 'shipped';

-- Show customers which are not in SP and RJ states
SELECT * 
FROM customers 
WHERE customer_state NOT IN ('SP', 'RJ');


-- Sorting customers in Descending order
SELECT * 
FROM customers 
ORDER BY customer_city DESC;


-- Sort the orders by date in descending order
SELECT * 
FROM orders 
ORDER BY order_purchase_timestamp DESC;


-- Show payments where the value is more than hundred in descding order 

SELECT * 
FROM payments 
WHERE payment_value > 100 
ORDER BY payment_value DESC;


-- show the number of payments, their sum, average, the maximum, and minimum 
SELECT 
    COUNT(*) as total_payments,
    SUM(payment_value) as total_revenue,
    AVG(payment_value) as average_payment,
    MIN(payment_value) as minimum_payment,
    MAX(payment_value) as maximum_payment
FROM payments;



-- GROUP BY

-- Group the customers by their states and count for each
SELECT customer_state, COUNT(*) as customer_count
FROM customers
GROUP BY customer_state;

-- Show the count of orders by their statuses
SELECT order_status, COUNT(*) as order_count
FROM orders
GROUP BY order_status;


-- Show the inventory of products by category
SELECT product_category_name, COUNT(*) as product_count
FROM products
GROUP BY product_category_name;

-- Show the average amount of payment by payment type
SELECT 
    payment_type, 
    COUNT(*) as payment_count,
    AVG(payment_value) as average_value
FROM payments
GROUP BY payment_type;

-- Show number of customers in each state in descinding order
SELECT customer_state, COUNT(*) as customer_count
FROM customers
GROUP BY customer_state
ORDER BY customer_count DESC;

-- Show states with more than 1000 customers
SELECT customer_state, COUNT(*) as customer_count
FROM customers
GROUP BY customer_state
HAVING COUNT(*) > 1000;

-- Show different categories with more than 100 products
SELECT product_category_name, COUNT(*) as product_count
FROM products
GROUP BY product_category_name
HAVING COUNT(*) > 100;


-- Show payment types with average value more than 50
SELECT payment_type, AVG(payment_value) as avg_value
FROM payments
GROUP BY payment_type
HAVING AVG(payment_value) > 50;

-- JOIN

-- Show orders with their customers city and states
SELECT 
    o.order_id, 
    o.order_status, 
    c.customer_city, 
    c.customer_state
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Show orders with their price and the category the belong in
SELECT 
    oi.order_id, 
    oi.price, 
    p.product_category_name
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id;

-- Show orders with their status, payment type and payment value
SELECT 
    o.order_id, 
    o.order_status, 
    p.payment_type, 
    p.payment_value
FROM orders o
INNER JOIN payments p ON o.order_id = p.order_id;

-- Show orders and their customer city and state along with payment type and value
SELECT 
    o.order_id,
    c.customer_city,
    c.customer_state,
    p.payment_type,
    p.payment_value
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN payments p ON o.order_id = p.order_id;

-- Show all customers and their orders including customers with no orders
SELECT 
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Show all products and their sales including products never sold
SELECT 
    p.product_id,
    p.product_category_name,
    oi.order_id,
    oi.price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id;

-- Show all orders and their customers 
SELECT 
    o.order_id,
    o.order_status,
    c.customer_city,
    c.customer_state
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- Show all payments and their orders
SELECT 
    p.order_id,
    p.payment_type,
    p.payment_value,
    o.order_status
FROM orders o
RIGHT JOIN payments p ON o.order_id = p.order_id;


-- TRIGGER

CREATE TABLE order_audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50),
    order_status VARCHAR(20),
    action_type VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



DELIMITER //

CREATE TRIGGER after_order_insert
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_audit_log (order_id, order_status, action_type)
    VALUES (NEW.order_id, NEW.order_status, 'INSERT');
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER after_order_delete
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_audit_log (order_id, order_status, action_type)
    VALUES (OLD.order_id, OLD.order_status, 'DELETE');
END //

DELIMITER ;


-- Test trigger
INSERT INTO orders (order_id, customer_id, order_status, order_purchase_timestamp)
VALUES ('trigger_test_001', 
        (SELECT customer_id FROM customers LIMIT 1), 
        'processing', 
        CURRENT_TIMESTAMP);

SELECT * FROM order_audit_log ORDER BY created_at DESC LIMIT 5;


-- Test trigger
DELETE FROM payments WHERE order_id = 'trigger_test_001';
DELETE FROM order_items WHERE order_id = 'trigger_test_001';
DELETE FROM orders WHERE order_id = 'trigger_test_001';

SELECT * FROM order_audit_log ORDER BY created_at DESC LIMIT 5;

SELECT 
    action_type,
    COUNT(*) as action_count
FROM order_audit_log
GROUP BY action_type;



-- TRANSACTION

-- Create a complete order with transaction
BEGIN;


INSERT INTO orders (order_id, customer_id, order_status, order_purchase_timestamp)
VALUES ('trans_order_001', '00012a2ce6f8dcda20d059ce98491703', 'processing', CURRENT_TIMESTAMP);


INSERT INTO order_items (order_id, order_item_id, product_id, seller_id, price, freight_value)
VALUES ('trans_order_001', 1, 
        (SELECT product_id FROM products LIMIT 1),
        (SELECT seller_id FROM sellers LIMIT 1),
        99.90, 10.00);


INSERT INTO payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
VALUES ('trans_order_001', 1, 'credit_card', 1, 109.90);


COMMIT;

-- Verify
SELECT * FROM orders WHERE order_id = 'trans_order_001';
SELECT * FROM order_items WHERE order_id = 'trans_order_001';
SELECT * FROM payments WHERE order_id = 'trans_order_001';



BEGIN;

-- Invalid customer_id
INSERT INTO orders (order_id, customer_id, order_status, order_purchase_timestamp)
VALUES ('rollback_test', 'invalid_customer_id', 'processing', CURRENT_TIMESTAMP);


ROLLBACK;


SELECT * FROM orders WHERE order_id = 'rollback_test';

