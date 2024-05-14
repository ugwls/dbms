-- 3. Sailor, Boats, and Reserves

-- i. Create tables
CREATE TABLE SAILOR (
    sid NUMBER PRIMARY KEY,
    sname VARCHAR2(50),
    rating NUMBER,
    age NUMBER
);

CREATE TABLE BOATS (
    bid NUMBER PRIMARY KEY,
    bname VARCHAR2(50),
    colour VARCHAR2(20)
);

CREATE TABLE RESERVES (
    sid NUMBER REFERENCES SAILOR(sid),
    bid NUMBER REFERENCES BOATS(bid),
    day DATE,
    PRIMARY KEY (sid, bid, day)
);

-- Insert sample data
INSERT INTO SAILOR VALUES (1, 'John', 7, 25);
INSERT INTO SAILOR VALUES (2, 'Jane', 5, 30);
-- Add more tuples as needed

INSERT INTO BOATS VALUES (101, 'Boat A', 'Red');
INSERT INTO BOATS VALUES (102, 'Boat B', 'Green');
-- Add more tuples as needed

INSERT INTO RESERVES VALUES (1, 101, '01-JUN-2022');
INSERT INTO RESERVES VALUES (2, 102, '15-JUN-2022');
-- Add more tuples as needed

-- ii. List sailors in descending order of rating
SELECT *
FROM SAILOR
ORDER BY rating DESC;

-- iii. List youngest sailor for each rating who can vote
SELECT s.*
FROM SAILOR s
INNER JOIN (
    SELECT rating, MIN(age) min_age
    FROM SAILOR
    WHERE age >= 18
    GROUP BY rating
) t ON s.rating = t.rating AND s.age = t.min_age;

-- iv. List sailors who reserved both 'Red' and 'Green' boats
SELECT s.sname
FROM SAILOR s
INNER JOIN RESERVES r1 ON s.sid = r1.sid
INNER JOIN BOATS b1 ON r1.bid = b1.bid
INNER JOIN RESERVES r2 ON s.sid = r2.sid AND r2.bid <> r1.bid
INNER JOIN BOATS b2 ON r2.bid = b2.bid
WHERE b1.colour = 'Red' AND b2.colour = 'Green';

-- v. PL/SQL to find factorial
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