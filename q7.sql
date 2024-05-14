-- 7. Banking Enterprise

-- i. Create tables
CREATE TABLE CUSTOMER_FIXED_DEPOSIT (
    cust_id NUMBER PRIMARY KEY,
    last_name VARCHAR2(50),
    mid_name VARCHAR2(50),
    first_name VARCHAR2(50),
    fixed_deposit_no NUMBER,
    amount NUMBER,
    rate_of_interest NUMBER
);

CREATE TABLE CUSTOMER_LOAN (
    loan_no NUMBER PRIMARY KEY,
    cust_id NUMBER REFERENCES CUSTOMER_FIXED_DEPOSIT(cust_id),
    amount NUMBER
);

CREATE TABLE CUSTOMER_DETAILS (
    cust_id NUMBER PRIMARY KEY,
    acc_type VARCHAR2(50)
);

-- Insert sample data
INSERT INTO CUSTOMER_FIXED_DEPOSIT VALUES (1, 'Doe', 'J', 'John', 101, 10000, 5);
INSERT INTO CUSTOMER_FIXED_DEPOSIT VALUES (2, 'Smith', 'A', 'Jane', 102, 15000, 6);
-- Add more tuples as needed

INSERT INTO CUSTOMER_LOAN VALUES (201, 1, 50000);
INSERT INTO CUSTOMER_LOAN VALUES (202, 2, 75000);
-- Add more tuples as needed

INSERT INTO CUSTOMER_DETAILS VALUES (1, 'Savings');
INSERT INTO CUSTOMER_DETAILS VALUES (2, 'Current');
-- Add more tuples as needed

-- ii. List customers with loan > 3,00,000
SELECT cf.first_name || ' ' || cf.mid_name || ' ' || cf.last_name AS customer_name
FROM CUSTOMER_FIXED_DEPOSIT cf
INNER JOIN CUSTOMER_LOAN cl ON cf.cust_id = cl.cust_id
WHERE cl.amount > 300000;

-- iii. List customers with same account type as 'jones simon'
SELECT cf.first_name || ' ' || cf.mid_name || ' ' || cf.last_name AS customer_name
FROM CUSTOMER_FIXED_DEPOSIT cf
INNER JOIN CUSTOMER_DETAILS cd ON cf.cust_id = cd.cust_id
WHERE cd.acc_type = (
    SELECT acc_type
    FROM CUSTOMER_DETAILS
    WHERE cust_id = (
        SELECT cust_id
        FROM CUSTOMER_FIXED_DEPOSIT
        WHERE last_name = 'jones' AND first_name = 'simon'
    )
);

-- iv. List customers without fixed deposit
SELECT cf.first_name || ' ' || cf.mid_name || ' ' || cf.last_name AS customer_name
FROM CUSTOMER_FIXED_DEPOSIT cf
WHERE NOT EXISTS (
    SELECT 1
    FROM CUSTOMER_LOAN cl
    WHERE cf.cust_id = cl.cust_id
);

-- v. PL/SQL to find factorial of n
CREATE OR REPLACE FUNCTION factorial(n NUMBER)
RETURN NUMBER
IS
    result NUMBER := 1;
BEGIN
    IF n = 0 THEN
        RETURN 1;
    ELSE
        FOR i IN 1..n LOOP
            result := result * i;
        END LOOP;
        RETURN result;
    END IF;
END;
/

DECLARE
    n NUMBER := 5;
    result NUMBER;
BEGIN
    result := factorial(n);
    DBMS_OUTPUT.PUT_LINE('Factorial of ' || n || ' is ' || result);
END;
/
