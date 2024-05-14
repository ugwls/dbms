-- 5. Student Enrollment and Book Adoption

-- i. Create tables
CREATE TABLE STUDENT (
    regno NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    major VARCHAR2(50),
    bdate DATE
);

CREATE TABLE COURSE (
    courseno NUMBER PRIMARY KEY,
    cname VARCHAR2(50),
    dept VARCHAR2(50)
);

CREATE TABLE ENROLL (
    regno NUMBER REFERENCES STUDENT(regno),
    courseno NUMBER REFERENCES COURSE(courseno),
    sem NUMBER,
    marks NUMBER,
    PRIMARY KEY (regno, courseno, sem)
);

CREATE TABLE BOOK_ADOPTION (
    courseno NUMBER REFERENCES COURSE(courseno),
    sem NUMBER,
    book_isbn NUMBER REFERENCES TEXT(book_isbn),
    PRIMARY KEY (courseno, sem, book_isbn)
);

CREATE TABLE TEXT (
    book_isbn NUMBER PRIMARY KEY,
    book_title VARCHAR2(100),
    publisher VARCHAR2(50),
    author VARCHAR2(50)
);

-- Insert sample data
INSERT INTO STUDENT VALUES (1, 'John Doe', 'Computer Science', '01-JAN-2000');
INSERT INTO STUDENT VALUES (2, 'Jane Smith', 'Electrical Engineering', '15-MAR-1999');
-- Add more tuples as needed

INSERT INTO COURSE VALUES (101, 'Database Systems', 'CS');
INSERT INTO COURSE VALUES (102, 'Data Structures', 'CS');
-- Add more tuples as needed

INSERT INTO ENROLL VALUES (1, 101, 1, 85);
INSERT INTO ENROLL VALUES (2, 102, 2, 90);
-- Add more tuples as needed

INSERT INTO TEXT VALUES (1001, 'Database Systems Concepts', 'McGraw-Hill', 'Silberschatz');
INSERT INTO TEXT VALUES (1002, 'Data Structures and Algorithms', 'Pearson', 'Cormen');
-- Add more tuples as needed

INSERT INTO BOOK_ADOPTION VALUES (101, 1, 1001);
INSERT INTO BOOK_ADOPTION VALUES (102, 2, 1002);
-- Add more tuples as needed

-- ii. Add a new text book and adopt it
INSERT INTO TEXT VALUES (1003, 'Introduction to Algorithms', 'MIT Press', 'Cormen');
INSERT INTO BOOK_ADOPTION VALUES (102, 2, 1003);

-- iii. List text books for CS department with more than 2 books
SELECT c.courseno, ba.book_isbn, t.book_title
FROM COURSE c
INNER JOIN BOOK_ADOPTION ba ON c.courseno = ba.courseno
INNER JOIN TEXT t ON ba.book_isbn = t.book_isbn
WHERE c.dept = 'CS'
GROUP BY c.courseno, ba.book_isbn, t.book_title
HAVING COUNT(ba.book_isbn) > 2
ORDER BY t.book_title;

-- iv. List departments with all books from a publisher
SELECT c.dept
FROM COURSE c
INNER JOIN BOOK_ADOPTION ba ON c.courseno = ba.courseno
INNER JOIN TEXT t ON ba.book_isbn = t.book_isbn
WHERE t.publisher = 'McGraw-Hill'
GROUP BY c.dept
HAVING COUNT(DISTINCT ba.book_isbn) = (
    SELECT COUNT(*)
    FROM TEXT
    WHERE publisher = 'McGraw-Hill'
);

-- v. PL/SQL to find topper among 'n' students
CREATE OR REPLACE FUNCTION find_topper(n NUMBER)
RETURN NUMBER
IS
    topper_regno NUMBER;
    max_marks NUMBER := 0;
BEGIN
    FOR rec IN (
        SELECT regno, MAX(marks) marks
        FROM ENROLL
        GROUP BY regno
        ORDER BY marks DESC
        FETCH FIRST n ROWS ONLY
    ) LOOP
        IF rec.marks > max_marks THEN
            max_marks := rec.marks;
            topper_regno := rec.regno;
        END IF;
    END LOOP;
    RETURN topper_regno;
END;
/

DECLARE
    n NUMBER := 5;
    topper NUMBER
    BEGIN
    topper := find_topper(n);
    DBMS_OUTPUT.PUT_LINE('Topper among ' || n || ' students has regno: ' || topper);
END;
/