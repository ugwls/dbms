-- 12. Company Database

-- i. Create tables
CREATE TABLE EMPLOYEE (
    eno NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    dob DATE,
    doj DATE,
    designation VARCHAR2(50),
    basicpay NUMBER,
    deptno NUMBER REFERENCES DEPARTMENT(deptno)
);

CREATE TABLE DEPARTMENT (
    deptno NUMBER PRIMARY KEY,
    name VARCHAR2(50)
);

CREATE TABLE PROJECT (
    projno NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    deptno NUMBER REFERENCES DEPARTMENT(deptno)
);

CREATE TABLE WORKSFOR (
    eno NUMBER REFERENCES EMPLOYEE(eno),
    projno NUMBER REFERENCES PROJECT(projno),
    hours NUMBER,
    PRIMARY KEY (eno, projno)
);

-- Insert sample data
INSERT INTO DEPARTMENT VALUES (101, 'IT');
INSERT INTO DEPARTMENT VALUES (102, 'Finance');
-- Add more tuples as needed

INSERT INTO EMPLOYEE VALUES (1001, 'John Doe', '01-JAN-1980', '01-JAN-2010', 'Manager', 50000, 101);
INSERT INTO EMPLOYEE VALUES (1002, 'Jane Smith', '15-MAR-1985', '15-MAR-2012', 'Developer', 40000, 101);
-- Add more tuples as needed

INSERT INTO PROJECT VALUES (2001, 'Project A', 101);
INSERT INTO PROJECT VALUES (2002, 'Project B', 102);
-- Add more tuples as needed

INSERT INTO WORKSFOR VALUES (1001, 2001, 40);
INSERT INTO WORKSFOR VALUES (1002, 2001, 80);
-- Add more tuples as needed

-- ii. List department number and number of employees
SELECT d.deptno, COUNT(e.eno) AS num_employees
FROM DEPARTMENT d
LEFT JOIN EMPLOYEE e ON d.deptno = e.deptno
GROUP BY d.deptno;

-- iii. List employees who worked on more than 3 projects
SELECT e.eno, e.name
FROM EMPLOYEE e
INNER JOIN WORKSFOR w ON e.eno = w.eno
GROUP BY e.eno, e.name
HAVING COUNT(DISTINCT w.projno) > 3;

-- iv. Create view for department, employees, and total basic pay
CREATE OR REPLACE VIEW dept_emp_pay AS
SELECT d.deptno, COUNT(e.eno) AS num_employees, SUM(e.basicpay) AS total_basic_pay
FROM DEPARTMENT d
LEFT JOIN EMPLOYEE e ON d.deptno = e.deptno
GROUP BY d.deptno;

-- v. PL/SQL to check Armstrong number
CREATE OR REPLACE FUNCTION is_armstrong(n NUMBER)
RETURN BOOLEAN
IS
    original_num NUMBER := n;
    num_digits NUMBER := LENGTH(n);
    sum_digits NUMBER := 0;
    remainder NUMBER;
BEGIN
    WHILE n > 0 LOOP
        remainder := MOD(n, 10);
        sum_digits := sum_digits + POWER(remainder, num_digits);
        n := TRUNC(n / 10);
    END LOOP;
    RETURN (original_num = sum_digits);
END;
/

DECLARE
    n NUMBER := 153;
    result BOOLEAN;
BEGIN
    result := is_armstrong(n);
    IF result THEN
        DBMS_OUTPUT.PUT_LINE(n || ' is an Armstrong number');
    ELSE
        DBMS_OUTPUT.PUT_LINE(n || ' is not an Armstrong number');
    END IF;
END;
/
