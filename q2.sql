-- 2. Employee and Department

-- i. Create tables
CREATE TABLE EMPLOYEE (
    empno NUMBER PRIMARY KEY,
    ename VARCHAR2(50),
    designation VARCHAR2(50),
    manager NUMBER,
    hiredate DATE,
    salary NUMBER,
    commission NUMBER,
    deptno NUMBER REFERENCES DEPARTMENT(deptno)
);

CREATE TABLE DEPARTMENT (
    deptno NUMBER PRIMARY KEY,
    dname VARCHAR2(50),
    location VARCHAR2(100)
);

-- Insert sample data
INSERT INTO DEPARTMENT VALUES (10, 'Accounting', 'New York');
INSERT INTO DEPARTMENT VALUES (20, 'Sales', 'Los Angeles');
-- Add more tuples as needed

INSERT INTO EMPLOYEE VALUES (1001, 'John Doe', 'Manager', NULL, '01-JAN-2010', 50000, NULL, 10);
INSERT INTO EMPLOYEE VALUES (1002, 'Jane Smith', 'Salesman', 1001, '15-MAR-2012', 35000, 5000, 20);
-- Add more tuples as needed

-- ii. List employees with 'LA' in name
SELECT ename
FROM EMPLOYEE
WHERE ename LIKE '%LA%';

-- iii. List employees with salary >= average salary
SELECT *
FROM EMPLOYEE
WHERE salary >= (SELECT AVG(salary) FROM EMPLOYEE);

-- iv. Create view for 'SALESMAN'
CREATE VIEW SALESMAN_VIEW AS
SELECT *
FROM EMPLOYEE
WHERE designation = 'Salesman';

-- v. PL/SQL to display empno, job, salary
DECLARE
    CURSOR emp_cursor IS
        SELECT empno, designation, salary
        FROM EMPLOYEE;
    emp_rec emp_cursor%ROWTYPE;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO emp_rec;
        EXIT WHEN emp_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Empno: ' || emp_rec.empno || ', Job: ' || emp_rec.designation || ', Salary: ' || emp_rec.salary);
    END LOOP;
    CLOSE emp_cursor;
END;
/