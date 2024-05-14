-- 13. Employee and Department

-- i. Create tables (same as Question 2 and Question 11)

-- Insert sample data
INSERT INTO DEPARTMENT VALUES (10, 'Accounting', 'New York');
INSERT INTO DEPARTMENT VALUES (20, 'Sales', 'Los Angeles');
INSERT INTO DEPARTMENT VALUES (30, 'IT', 'Chicago');
-- Add more tuples as needed

INSERT INTO EMPLOYEE VALUES (1001, 'John Doe', 'Manager', 1003, '01-JAN-2010', 50000, 5000, 10);
INSERT INTO EMPLOYEE VALUES (1002, 'Jane Smith', 'Clerk', 1001, '15-MAR-2012', 35000, 3000, 20);
INSERT INTO EMPLOYEE VALUES (1003, 'Bob Johnson', 'Manager', NULL, '01-JUN-2008', 60000, NULL, 30);
-- Add more tuples as needed

-- ii. List employees with salary > any employee in dept 30
SELECT e.*
FROM EMPLOYEE e
WHERE e.salary > ANY (
    SELECT salary
    FROM EMPLOYEE
    WHERE deptno = 30
);

-- iii. List name, job, salary of employees in dept with highest avg salary
SELECT e.ename, e.designation, e.salary
FROM EMPLOYEE e
INNER JOIN (
    SELECT deptno, AVG(salary) AS avg_salary
    FROM EMPLOYEE
    GROUP BY deptno
    ORDER BY avg_salary DESC
    FETCH FIRST 1 ROW ONLY
) d ON e.deptno = d.deptno;

-- iv. List employees who are managers or analysts with salary 2000-5000
SELECT *
FROM EMPLOYEE
WHERE (designation = 'Manager' OR designation = 'Analyst')
  AND salary BETWEEN 2000 AND 5000;

-- v. Trigger to prevent DML operations on EMPLOYEE table
CREATE OR REPLACE TRIGGER prevent_dml
BEFORE INSERT OR UPDATE OR DELETE ON EMPLOYEE
BEGIN
    RAISE_APPLICATION_ERROR(-20000, 'DML operations are not allowed on EMPLOYEE table.');
END;
/
