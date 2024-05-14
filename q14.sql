-- 14. Transport Management System

-- i. Identify foreign keys and draw schema diagram
-- Foreign keys:
-- ASSIGN_ROUTE(DID) references DRIVER(DID)
-- ASSIGN_ROUTE(ROUTENO) references BUS(ROUTENO)

-- Schema diagram:
/*
    DRIVER
    -------
    DID (PK)
    DNAME
    DOB
    GENDER

    BUS
    -----
    ROUTENO (PK)
    SOURCE
    DESTINATION

    ASSIGN_ROUTE
    ------------
    DID (FK - DRIVER)
    ROUTENO (FK - BUS)
    JOURNEY_DATE
    (DID, ROUTENO, JOURNEY_DATE) (PK)
*/

-- ii. Create tables and populate data
CREATE TABLE DRIVER (
    DID NUMBER PRIMARY KEY,
    DNAME VARCHAR2(50),
    DOB DATE,
    GENDER VARCHAR2(10)
);

CREATE TABLE BUS (
    ROUTENO VARCHAR2(10) PRIMARY KEY,
    SOURCE VARCHAR2(50),
    DESTINATION VARCHAR2(50)
);

CREATE TABLE ASSIGN_ROUTE (
    DID NUMBER REFERENCES DRIVER(DID),
    ROUTENO VARCHAR2(10) REFERENCES BUS(ROUTENO),
    JOURNEY_DATE DATE,
    PRIMARY KEY (DID, ROUTENO, JOURNEY_DATE)
);

-- Insert sample data
INSERT INTO DRIVER VALUES (101, 'John Doe', '01-JAN-1980', 'Male');
INSERT INTO DRIVER VALUES (102, 'Jane Smith', '15-MAR-1985', 'Male');
-- Add more tuples as needed

INSERT INTO BUS VALUES ('R001', 'New York', 'Boston');
INSERT INTO BUS VALUES ('R002', 'Los Angeles', 'San Francisco');
-- Add more tuples as needed

INSERT INTO ASSIGN_ROUTE VALUES (101, 'R001', '01-MAY-2023');
INSERT INTO ASSIGN_ROUTE VALUES (102, 'R002', '15-MAY-2023');
-- Add more tuples as needed

-- iii. Include constraints
ALTER TABLE BUS ADD CONSTRAINT route_prefix CHECK (ROUTENO LIKE 'R%');
ALTER TABLE DRIVER ADD CONSTRAINT gender_constraint CHECK (GENDER = 'Male');

-- iv. List drivers who traveled more than 3 times on the same route
SELECT d.DID, d.DNAME
FROM DRIVER d
INNER JOIN ASSIGN_ROUTE ar ON d.DID = ar.DID
GROUP BY d.DID, d.DNAME
HAVING COUNT(DISTINCT ar.ROUTENO) > 3;

-- v. PL/SQL to check if a number is odd or even
CREATE OR REPLACE FUNCTION is_even(n NUMBER)
RETURN BOOLEAN
IS
BEGIN
    RETURN MOD(n, 2) = 0;
END;
/

DECLARE
    n NUMBER := 7;
    result BOOLEAN;
BEGIN
    result := is_even(n);
    IF result THEN
        DBMS_OUTPUT.PUT_LINE(n || ' is even');
    ELSE
        DBMS_OUTPUT.PUT_LINE(n || ' is odd');
    END IF;
END;
/
