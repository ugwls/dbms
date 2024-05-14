-- 10. Employee, Works, Company, and Manages

-- i. Create tables
CREATE TABLE EMPLOYEE (
    empname VARCHAR2(50) PRIMARY KEY,
    street VARCHAR2(100),
    city VARCHAR2(50)
);

CREATE TABLE WORKS (
    empname VARCHAR2(50) REFERENCES EMPLOYEE(empname),
    companyname VARCHAR2(50) REFERENCES COMPANY(companyname),
    salary NUMBER,
    PRIMARY KEY (empname, companyname)
);

CREATE TABLE COMPANY (
    companyname VARCHAR2(50) PRIMARY KEY,
    city VARCHAR2(50)
);

CREATE TABLE MANAGES (
    empname VARCHAR2(50) REFERENCES EMPLOYEE(empname),
    managername VARCHAR2(50) REFERENCES EMPLOYEE(empname),
    PRIMARY KEY (empname, managername)
);

-- Insert sample data
INSERT INTO EMPLOYEE VALUES ('John Doe', '123 Main St.', 'New York');
INSERT INTO EMPLOYEE VALUES ('Jane Smith', '456 Elm St.', 'Los Angeles');
-- Add more tuples as needed

INSERT INTO COMPANY VALUES ('First Bank Corporation', 'New York');
INSERT INTO COMPANY VALUES ('Acme Inc.', 'Los Angeles');
-- Add more tuples as needed

INSERT INTO WORKS VALUES ('John Doe', 'First Bank Corporation', 100000);
INSERT INTO WORKS VALUES ('Jane Smith', 'Acme Inc.', 80000);
-- Add more tuples as needed

INSERT INTO MANAGES VALUES ('John Doe', 'Jane Smith');
INSERT INTO MANAGES VALUES ('Jane Smith', 'John Doe');
-- Add more tuples as needed

-- ii. Find employees working for 'First Bank Corporation'
SELECT e.empname
FROM EMPLOYEE e
INNER JOIN
WORKS w ON e.empname = w.empname
WHERE w.companyname = 'First Bank Corporation';

-- iii. Find employees of 'First Bank Corporation' earning > 200000
SELECT e.empname, e.street, e.city
FROM EMPLOYEE e
INNER JOIN WORKS w ON e.empname = w.empname
WHERE w.companyname = 'First Bank Corporation' AND w.salary > 200000;

-- iv. Find employees living in the same city as their company
SELECT e.empname
FROM EMPLOYEE e
INNER JOIN WORKS w ON e.empname = w.empname
INNER JOIN COMPANY c ON w.companyname = c.companyname
WHERE e.city = c.city;

-- v. PL/SQL to calculate electricity bill
CREATE OR REPLACE FUNCTION calculate_electricity_bill(units NUMBER)
RETURN NUMBER
IS
    bill_amount NUMBER;
BEGIN
    IF units <= 100 THEN
        bill_amount := units * 5;
    ELSIF units <= 200 THEN
        bill_amount := 100 * 5 + (units - 100) * 7;
    ELSE
        bill_amount := 100 * 5 + 100 * 7 + (units - 200) * 10;
    END IF;
    RETURN bill_amount;
END;
/

DECLARE
    units NUMBER := 250;
    bill_amount NUMBER;
BEGIN
    bill_amount := calculate_electricity_bill(units);
    DBMS_OUTPUT.PUT_LINE('Electricity bill for ' || units || ' units: ' || bill_amount);
END;
/
