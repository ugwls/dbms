-- 1. Insurance Database

-- i. Create tables
CREATE TABLE PERSON (
    driver_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    address VARCHAR2(100)
);

CREATE TABLE CAR (
    regno VARCHAR2(10) PRIMARY KEY,
    model VARCHAR2(50),
    year NUMBER
);

CREATE TABLE ACCIDENT (
    report_number NUMBER PRIMARY KEY,
    accd_date DATE,
    location VARCHAR2(100)
);

CREATE TABLE OWNS (
    driver_id NUMBER REFERENCES PERSON(driver_id),
    regno VARCHAR2(10) REFERENCES CAR(regno),
    PRIMARY KEY (driver_id, regno)
);

CREATE TABLE PARTICIPATED (
    driver_id NUMBER REFERENCES PERSON(driver_id),
    regno VARCHAR2(10) REFERENCES CAR(regno),
    report_number NUMBER REFERENCES ACCIDENT(report_number),
    damage_amount NUMBER,
    PRIMARY KEY (driver_id, regno, report_number)
);

-- Insert sample data
INSERT INTO PERSON VALUES (1, 'John Doe', '123 Main St.');
INSERT INTO PERSON VALUES (2, 'Jane Smith', '456 Elm St.');
-- Add more tuples as needed

INSERT INTO CAR VALUES ('ABC123', 'Toyota Camry', 2015);
INSERT INTO CAR VALUES ('DEF456', 'Honda Civic', 2018);
-- Add more tuples as needed

INSERT INTO ACCIDENT VALUES (1, '01-JAN-2022', 'Main St. and Elm St.');
INSERT INTO ACCIDENT VALUES (2, '15-FEB-2022', 'Highway 101');
-- Add more tuples as needed

INSERT INTO OWNS VALUES (1, 'ABC123');
INSERT INTO OWNS VALUES (2, 'DEF456');
-- Add more tuples as needed

INSERT INTO PARTICIPATED VALUES (1, 'ABC123', 1, 10000);
INSERT INTO PARTICIPATED VALUES (2, 'DEF456', 2, 15000);
-- Add more tuples as needed

-- ii. Update damage amount
UPDATE PARTICIPATED
SET damage_amount = 25000
WHERE report_number = 12 AND regno = 'ABC123';

-- iii. Add a new accident
INSERT INTO ACCIDENT VALUES (3, '30-APR-2022', 'Main St. and Oak St.');
INSERT INTO PARTICIPATED VALUES (1, 'ABC123', 3, 8000);

-- iv. Find people who owned cars involved in accidents in 2008
SELECT COUNT(DISTINCT p.driver_id)
FROM PERSON p
INNER JOIN OWNS o ON p.driver_id = o.driver_id
INNER JOIN PARTICIPATED pt ON o.regno = pt.regno
INNER JOIN ACCIDENT a ON pt.report_number = a.report_number
WHERE a.accd_date BETWEEN '01-JAN-2008' AND '31-DEC-2008';

-- v. PL/SQL to find sum of first n natural numbers
CREATE OR REPLACE FUNCTION sum_of_n(n NUMBER)
RETURN NUMBER
IS
    total NUMBER := 0;
BEGIN
    FOR i IN 1..n LOOP
        total := total + i;
    END LOOP;
    RETURN total;
END;
/

DECLARE
    n NUMBER := 10;
    result NUMBER;
BEGIN
    result := sum_of_n(n);
    DBMS_OUTPUT.PUT_LINE('Sum of first ' || n || ' natural numbers: ' || result);
END;
/