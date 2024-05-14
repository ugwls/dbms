-- 8. Customer, Item, Invoice, and InvItem

-- i. Create tables
CREATE TABLE CUSTOMER (
    custno NUMBER PRIMARY KEY,
    custname VARCHAR2(50),
    city VARCHAR2(50),
    phone VARCHAR2(20)
);

CREATE TABLE ITEM (
    itemno NUMBER PRIMARY KEY,
    itemname VARCHAR2(50),
    itemprice NUMBER,
    quantity NUMBER
);

CREATE TABLE INVOICE (
    invno NUMBER PRIMARY KEY,
    invdate DATE,
    custno NUMBER REFERENCES CUSTOMER(custno)
);

CREATE TABLE INVITEM (
    invno NUMBER REFERENCES INVOICE(invno),
    itemno NUMBER REFERENCES ITEM(itemno),
    quantity NUMBER,
    PRIMARY KEY (invno, itemno)
);

-- Insert sample data
INSERT INTO CUSTOMER VALUES (1, 'John Doe', 'New York', '1234567890');
INSERT INTO CUSTOMER VALUES (2, 'Jane Smith', 'Los Angeles', '9876543210');
-- Add more tuples as needed

INSERT INTO ITEM VALUES (101, 'Shirt', 25, 50);
INSERT INTO ITEM VALUES (102, 'Pants', 35, 75);
-- Add more tuples as needed

INSERT INTO INVOICE VALUES (10001, '01-JAN-2022', 1);
INSERT INTO INVOICE VALUES (10002, '15-FEB-2022', 2);
-- Add more tuples as needed

INSERT INTO INVITEM VALUES (10001, 101, 2);
INSERT INTO INVITEM VALUES (10002, 102, 3);
-- Add more tuples as needed

-- ii. Display item names and quantities sold
SELECT i.itemname, SUM(ii.quantity) AS quantity_sold
FROM ITEM i
INNER JOIN INVITEM ii ON i.itemno = ii.itemno
GROUP BY i.itemname;

-- iii. Display item name and price as single column
SELECT itemname || ' price is ' || itemprice AS item_price
FROM ITEM;

-- iv. Display invoices, customer names, and item names
SELECT i.invno, c.custname, it.itemname
FROM INVOICE i
INNER JOIN CUSTOMER c ON i.custno = c.custno
INNER JOIN INVITEM ii ON i.invno = ii.invno
INNER JOIN ITEM it ON ii.itemno = it.itemno;

-- v. PL/SQL to calculate and print employee pay slip
CREATE OR REPLACE PROCEDURE print_pay_slip(
    emp_id IN NUMBER,
    basic_pay OUT NUMBER,
    hra OUT NUMBER,
    da OUT NUMBER,
    gross_pay OUT NUMBER
)
IS
BEGIN
    -- Fetch basic pay from employee table
    SELECT salary INTO basic_pay
    FROM EMPLOYEE
    WHERE empno = emp_id;

    -- Calculate HRA (15% of basic pay)
    hra := basic_pay * 0.15;

    -- Calculate DA (10% of basic pay)
    da := basic_pay * 0.1;

    -- Calculate gross pay
    gross_pay := basic_pay + hra + da;

    DBMS_OUTPUT.PUT_LINE('Pay Slip for Employee ' || emp_id);
    DBMS_OUTPUT.PUT_LINE('Basic Pay: ' || basic_pay);
    DBMS_OUTPUT.PUT_LINE('HRA: ' || hra);
    DBMS_OUTPUT.PUT_LINE('DA: ' || da);
    DBMS_OUTPUT.PUT_LINE('Gross Pay: ' || gross_pay);
END;
/

DECLARE
    emp_id NUMBER := 1001;
    basic_pay NUMBER;
    hra NUMBER;
    da NUMBER;
    gross_pay NUMBER;
BEGIN
    print_pay_slip(emp_id, basic_pay, hra, da, gross_pay);
END;
/
