-- 16. Products Order Database

-- i. Identify foreign keys and draw schema diagram
-- Foreign keys:
-- ORDER_DETAILS(order_number) references ORDERS(order_id)
-- ORDER_DETAILS(product_number) references PRODUCTS(p_id)

-- Schema diagram:
/*
    PRODUCTS
    ---------
    p_id (PK)
    p_name
    retail_price
    qty_on_hand

    ORDERS
    -------
    order_id (PK)
    order_date

    ORDER_DETAILS
    -------------
    order_number (FK - ORDERS)
    product_number (FK - PRODUCTS)
    qty_ordered
    (order_number, product_number) (PK)
*/

-- ii. Create tables and populate data
CREATE TABLE PRODUCTS (
    p_id NUMBER PRIMARY KEY,
    p_name VARCHAR2(50),
    retail_price NUMBER,
    qty_on_hand NUMBER
);

CREATE TABLE ORDERS (
    order_id NUMBER PRIMARY KEY,
    order_date DATE
);

CREATE TABLE ORDER_DETAILS (
    order_number NUMBER REFERENCES ORDERS(order_id),
    product_number NUMBER REFERENCES PRODUCTS(p_id),
    qty_ordered NUMBER,
    PRIMARY KEY (order_number, product_number)
);

-- Insert sample data
INSERT INTO PRODUCTS VALUES (1001, 'Product A', 10.99, 100);
INSERT INTO PRODUCTS VALUES (1002, 'Product B', 15.99, 50);
-- Add more tuples as needed

INSERT INTO ORDERS VALUES (5001, '01-MAY-2023');
INSERT INTO ORDERS VALUES (5002, '15-MAY-2023');
-- Add more tuples as needed

INSERT INTO ORDER_DETAILS VALUES (5001, 1001, 5);
INSERT INTO ORDER_DETAILS VALUES (5002, 1002, 10);
-- Add more tuples as needed

-- iii. Include constraint on order_id
ALTER TABLE ORDERS ADD CONSTRAINT order_prefix CHECK (order_id LIKE 'O%');

-- iv. Display product ID and sum of quantity ordered
SELECT product_number, SUM(qty_ordered) AS total_qty
FROM ORDER_DETAILS
GROUP BY product_number;

-- v. Create view for product details, order details, and ordered date
CREATE OR REPLACE VIEW product_order_view AS
SELECT p.p_id, p.retail_price, o.order_id, od.qty_ordered, o.order_date
FROM PRODUCTS p
INNER JOIN ORDER_DETAILS od ON p.p_id = od.product_number
INNER JOIN ORDERS o ON od.order_number = o.order_id;

-- vi. Trigger to delete order from ORDERS after deleting from ORDER_DETAILS
CREATE OR REPLACE TRIGGER delete_order
AFTER DELETE ON ORDER_DETAILS
FOR EACH ROW
BEGIN
    DELETE FROM ORDERS
    WHERE order_id = :OLD.order_number
      AND NOT EXISTS (
        SELECT 1
        FROM ORDER_DETAILS
        WHERE order_number = :OLD.order_number
    );
END;
/
