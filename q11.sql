-- 11. Employee and Department

-- i. Create tables (same as Question 2)

-- Insert sample data
INSERT INTO DEPARTMENT VALUES (10, 'Accounting', 'New York');
INSERT INTO DEPARTMENT VALUES (20, 'Sales', 'Los Angeles');
-- Add more tuples as needed

INSERT INTO EMPLOYEE VALUES (1001, 'John Doe', 'Manager', NULL, '01-JAN-2010', 50000, 5000, 10);
INSERT INTO EMPLOYEE VALUES (1002, 'Jane Smith', 'Clerk', 1001, '15-MAR-2012', 35000, 3000, 20);
-- Add more tuples as needed

-- ii. List employees with annual salary between 22000 and 25000
SELECT *
FROM EMPLOYEE
WHERE salary * 12 BETWEEN 22000 AND 25000;

-- iii. List employees with their manager names
SELECT e.ename, m.ename AS manager_name
FROM EMPLOYEE e
LEFT JOIN EMPLOYEE m ON e.manager = m.empno;

-- iv. List department with maximum number of clerks
SELECT d.dname, COUNT(*) AS num_clerks
FROM DEPARTMENT d
INNER JOIN EMPLOYEE e ON d.deptno = e.deptno
WHERE e.designation = 'Clerk'
GROUP BY d.dname
ORDER BY num_clerks DESC
FETCH FIRST 1 ROW ONLY;

-- v. Trigger to ensure salary > commission
CREATE OR REPLACE TRIGGER validate_salary
BEFORE INSERT OR UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF :NEW.salary < :NEW.commission THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be less than commission');
    END IF;
END;
/
