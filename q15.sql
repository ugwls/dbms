-- 15. Transport Management System

-- i. Identify foreign keys and draw schema diagram
-- Foreign keys:
-- DRIVE_TRUCK(DCODE) references DRIVER(DCODE)
-- DRIVE_TRUCK(TRUCKCODE) references TRUCK(TRUCKCODE)
-- DRIVE_TRUCK(CCODE) references CITY(CCODE)

-- Schema diagram:
/*
    DRIVER
    -------
    DCODE (PK)
    DNAME
    DOB
    GENDER

    CITY
    -----
    CCODE (PK)
    CNAME

    TRUCK
    ------
    TRUCKCODE (PK)
    TTYPE

    DRIVE_TRUCK
    -----------
    TRUCKCODE (FK - TRUCK)
    DCODE (FK - DRIVER)
    DOT
    CCODE (FK - CITY)
    (TRUCKCODE, DCODE, DOT, CCODE) (PK)
*/

-- ii. Create tables and populate data
CREATE TABLE DRIVER (
    DCODE NUMBER PRIMARY KEY,
    DNAME VARCHAR2(50),
    DOB DATE,
    GENDER VARCHAR2(10)
);

CREATE TABLE CITY (
    CCODE NUMBER PRIMARY KEY,
    CNAME VARCHAR2(50)
);

CREATE TABLE TRUCK (
    TRUCKCODE NUMBER PRIMARY KEY,
    TTYPE VARCHAR2(10)
);

CREATE TABLE DRIVE_TRUCK (
    TRUCKCODE NUMBER REFERENCES TRUCK(TRUCKCODE),
    DCODE NUMBER REFERENCES DRIVER(DCODE),
    DOT DATE,
    CCODE NUMBER REFERENCES CITY(CCODE),
    PRIMARY KEY (TRUCKCODE, DCODE, DOT, CCODE)
);

-- Insert sample data
INSERT INTO DRIVER VALUES (201, 'John Doe', '01-JAN-1980', 'Male');
INSERT INTO DRIVER VALUES (202, 'Jane Smith', '15-MAR-1985', 'Male');
-- Add more tuples as needed

INSERT INTO CITY VALUES (1001, 'New York');
INSERT INTO CITY VALUES (1002, 'Los Angeles');
-- Add more tuples as needed

INSERT INTO TRUCK VALUES (3001, 'L');
INSERT INTO TRUCK VALUES (3002, 'H');
-- Add more tuples as needed

INSERT INTO DRIVE_TRUCK VALUES (3001, 201, '01-MAY-2023', 1001);
INSERT INTO DRIVE_TRUCK VALUES (3002, 202, '15-MAY-2023', 1002);
-- Add more tuples as needed

-- iii. Include constraints
ALTER TABLE DRIVER ADD CONSTRAINT gender_constraint CHECK (GENDER = 'Male');
ALTER TABLE TRUCK ADD CONSTRAINT truck_type_constraint CHECK (TTYPE IN ('L', 'H'));

-- iv. List driver details and number of trips traveled
SELECT d.DCODE, d.DNAME, COUNT(*) AS num_trips
FROM DRIVER d
INNER JOIN DRIVE_TRUCK dt ON d.DCODE = dt.DCODE
GROUP BY d.DCODE, d.DNAME;

-- v. Create view for driver details and city
CREATE OR REPLACE VIEW driver_city_view AS
SELECT d.DCODE, d.DNAME, d.DOB, d.GENDER, c.CNAME
FROM DRIVER d
INNER JOIN DRIVE_TRUCK dt ON d.DCODE = dt.DCODE
INNER JOIN CITY c ON dt.CCODE = c.CCODE;
