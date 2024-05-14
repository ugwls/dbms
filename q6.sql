-- 6. Book Dealer

-- i. Create tables
CREATE TABLE AUTHOR (
    author_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    city VARCHAR2(50),
    country VARCHAR2(50)
);

CREATE TABLE PUBLISHER (
    publisher_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    city VARCHAR2(50),
    country VARCHAR2(50)
);

CREATE TABLE CATEGORY (
    category_id NUMBER PRIMARY KEY,
    description VARCHAR2(100)
);

CREATE TABLE CATALOG (
    book_id NUMBER PRIMARY KEY,
    title VARCHAR2(100),
    author_id NUMBER REFERENCES AUTHOR(author_id),
    publisher_id NUMBER REFERENCES PUBLISHER(publisher_id),
    category_id NUMBER REFERENCES CATEGORY(category_id),
    year NUMBER,
    price NUMBER
);

CREATE TABLE ORDER_DETAILS (
    order_no NUMBER PRIMARY KEY,
    book_id NUMBER REFERENCES CATALOG(book_id),
    quantity NUMBER
);

-- Insert sample data
INSERT INTO AUTHOR VALUES (1, 'J.K. Rowling', 'London', 'UK');
INSERT INTO AUTHOR VALUES (2, 'Stephen King', 'Portland', 'USA');
-- Add more tuples as needed

INSERT INTO PUBLISHER VALUES (101, 'Scholastic', 'New York', 'USA');
INSERT INTO PUBLISHER VALUES (102, 'Penguin', 'London', 'UK');
-- Add more tuples as needed

INSERT INTO CATEGORY VALUES (1001, 'Fiction');
INSERT INTO CATEGORY VALUES (1002, 'Non-Fiction');
-- Add more tuples as needed

INSERT INTO CATALOG VALUES (10001, 'Harry Potter and the Sorcerer''s Stone', 1, 101, 1001, 1997, 15.99);
INSERT INTO CATALOG VALUES (10002, 'The Shining', 2, 101, 1001, 1977, 12.99);
-- Add more tuples as needed

INSERT INTO ORDER_DETAILS VALUES (5001, 10001, 10);
INSERT INTO ORDER_DETAILS VALUES (5002, 10002, 5);
-- Add more tuples as needed

-- ii. Details of authors with 2+ books, price > avg, year > 2000
SELECT a.name, c.title, c.price
FROM AUTHOR a
INNER JOIN CATALOG c ON a.author_id = c.author_id
WHERE c.year > 2000 AND c.price > (SELECT AVG(price) FROM CATALOG)
GROUP BY a.name, c.title, c.price
HAVING COUNT(c.book_id) >= 2;

-- iii. Find author of book with maximum sales
SELECT a.name
FROM AUTHOR a
INNER JOIN CATALOG c ON a.author_id = c.author_id
INNER JOIN ORDER_DETAILS od ON c.book_id = od.book_id
GROUP BY a.name
ORDER BY SUM(od.quantity) DESC
FETCH FIRST 1 ROW ONLY;

-- iv. Increase price of books by a publisher by 10%
UPDATE CATALOG
SET price = price * 1.1
WHERE publisher_id = (SELECT publisher_id FROM PUBLISHER WHERE name = 'Scholastic');

-- v. PL/SQL to find total marks for n students
CREATE OR REPLACE FUNCTION total_marks(n NUMBER)
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
    result := total_marks(n);
    DBMS_OUTPUT.PUT_LINE('Total marks for ' || n || ' students: ' || result);
END;
/
