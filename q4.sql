-- 4. Order Processing Database

-- i. Create tables
CREATE TABLE CUSTOMER (
    custno NUMBER PRIMARY KEY,
    cname VARCHAR2(50),
    city VARCHAR2(50)
);

CREATE TABLE ORDER_MAIN (
    orderno NUMBER PRIMARY KEY,
    odate DATE,
    custno NUMBER REFERENCES CUSTOMER(custno),
    ord_amt NUMBER
);

CREATE TABLE ORDER_ITEM (
    orderno NUMBER REFERENCES ORDER_MAIN(orderno),
    itemno NUMBER,
    quantity NUMBER,
    PRIMARY KEY (orderno, itemno)
);

CREATE TABLE ITEM (
    itemno NUMBER PRIMARY KEY,
    unitprice NUMBER
);

CREATE TABLE SHIPMENT (
    orderno NUMBER REFERENCES ORDER_MAIN(orderno),
    warehouseno NUMBER REFERENCES WAREHOUSE(warehouseno),
    ship_date DATE,
    PRIMARY KEY (orderno, warehouseno, ship_date)
);

CREATE TABLE WAREHOUSE (
    warehouseno NUMBER PRIMARY KEY,
    city VARCHAR2(50)
);

-- Insert sample data
INSERT INTO CUSTOMER VALUES (1, 'John Doe', 'New York');
INSERT INTO CUSTOMER VALUES (2, 'Jane Smith', 'Los Angeles');
-- Add more tuples as needed

INSERT INTO ORDER_MAIN VALUES (101, '01-JAN-2022', 1, 1000);
INSERT INTO ORDER_MAIN VALUES (102, '15-FEB-2022', 2, 2000);
-- Add more tuples as needed

INSERT INTO ORDER_ITEM VALUES (101, 1, 5);
INSERT INTO ORDER_ITEM VALUES (102, 2, 10);
-- Add more tuples as needed

INSERT INTO ITEM VALUES (1, 100);
INSERT INTO ITEM VALUES (2, 150);
-- Add more tuples as needed

INSERT INTO WAREHOUSE VALUES (1, 'New York');
INSERT INTO WAREHOUSE VALUES (2, 'Los Angeles');
-- Add more tuples as needed

INSERT INTO SHIPMENT VALUES (101, 1, '05-JAN-2022');
INSERT INTO SHIPMENT VALUES (102, 2, '20-FEB-2022');
-- Add more tuples as needed

-- ii. List custname, No_of_orders, Avg_order_amount
SELECT c.cname, COUNT(o.orderno) No_of_orders, AVG(o.ord_amt) Avg_order_amount
FROM CUSTOMER c
LEFT JOIN ORDER_MAIN o ON c.custno = o.custno
GROUP BY c.cname;

-- iii. List orderno shipped from all warehouses in a city
SELECT o.orderno
FROM ORDER_MAIN o
INNER JOIN SHIPMENT s ON o.orderno = s.orderno
INNER JOIN WAREHOUSE w ON s.warehouseno = w.warehouseno
WHERE w.city = 'New York'
GROUP BY o.orderno
HAVING COUNT(DISTINCT s.warehouseno) = (SELECT COUNT(*) FROM WAREHOUSE WHERE city = 'New York');

-- iv. Demonstrate deletion of an item and handling ORDER_ITEM
DELETE FROM ITEM WHERE itemno = 1;

-- After deletion, update ORDER_ITEM to remove references to deleted item
UPDATE ORDER_ITEM SET itemno = NULL WHERE itemno = 1;

-- v. PL/SQL to generate Fibonacci series
CREATE OR REPLACE FUNCTION fibonacci(n NUMBER)
RETURN NUMBER
IS
    a NUMBER := 0;
    b NUMBER := 1;
    temp NUMBER;
    result NUMBER := 0;
BEGIN
    IF n = 0 THEN
        RETURN a;
    ELSIF n = 1 THEN
        RETURN b;
    ELSE
        FOR i IN 2..n LOOP
            temp := b;
            b := a + b;
            a := temp;
        END LOOP;
        RETURN b;
    END IF;
END;
/

DECLARE
    n NUMBER := 10;
    result NUMBER;
BEGIN
    FOR i IN 0..n LOOP
        result := fibonacci(i);
        DBMS_OUTPUT.PUT_LINE('Fibonacci(' || i || ') = ' || result);
    END LOOP;
END;
/
