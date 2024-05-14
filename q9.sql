-- 9. Banking Enterprise

-- i. Create tables
CREATE TABLE BRANCH (
    branch_name VARCHAR2(50) PRIMARY KEY,
    branch_city VARCHAR2(50),
    assets NUMBER
);

CREATE TABLE ACCOUNT (
    accno NUMBER PRIMARY KEY,
    branch_name VARCHAR2(50) REFERENCES BRANCH(branch_name),
    balance NUMBER
);

CREATE TABLE DEPOSITOR (
    customer_name VARCHAR2(50) PRIMARY KEY,
    accno NUMBER REFERENCES ACCOUNT(accno)
);

CREATE TABLE CUSTOMER (
    customer_name VARCHAR2(50) PRIMARY KEY,
    customer_street VARCHAR2(100),
    customer_city VARCHAR2(50)
);

CREATE TABLE LOAN (
    loan_number NUMBER PRIMARY KEY,
    branch_name VARCHAR2(50) REFERENCES BRANCH(branch_name),
    amount NUMBER
);

CREATE TABLE BORROWER (
    customer_name VARCHAR2(50) REFERENCES CUSTOMER(customer_name),
    loan_number NUMBER REFERENCES LOAN(loan_number),
    PRIMARY KEY (customer_name, loan_number)
);

-- Insert sample data
INSERT INTO BRANCH VALUES ('Main Branch', 'New York', 100000000);
INSERT INTO BRANCH VALUES ('Branch A', 'Los Angeles', 50000000);
-- Add more tuples as needed

INSERT INTO ACCOUNT VALUES (1001, 'Main Branch', 25000);
INSERT INTO ACCOUNT VALUES (1002, 'Branch A', 40000);
-- Add more tuples as needed

INSERT INTO DEPOSITOR VALUES ('John Doe', 1001);
INSERT INTO DEPOSITOR VALUES ('Jane Smith', 1002);
-- Add more tuples as needed

INSERT INTO CUSTOMER VALUES ('John Doe', '123 Main St.', 'New York');
INSERT INTO CUSTOMER VALUES ('Jane Smith', '456 Elm St.', 'Los Angeles');
-- Add more tuples as needed

INSERT INTO LOAN VALUES (2001, 'Main Branch', 100000);
INSERT INTO LOAN VALUES (2002, 'Branch A', 150000);
-- Add more tuples as needed

INSERT INTO BORROWER VALUES ('John Doe', 2001);
INSERT INTO BORROWER VALUES ('Jane Smith', 2002);
-- Add more tuples as needed

-- ii. Display customers who are depositors and borrowers
SELECT c.customer_name
FROM CUSTOMER c
INNER JOIN DEPOSITOR d ON c.customer_name = d.customer_name
INNER JOIN BORROWER b ON c.customer_name = b.customer_name;

-- iii. Display customers who are only depositors
SELECT c.customer_name
FROM CUSTOMER c
INNER JOIN DEPOSITOR d ON c.customer_name = d.customer_name
LEFT JOIN BORROWER b ON c.customer_name = b.customer_name
WHERE b.customer_name IS NULL;

-- iv. Display branches with assets greater than Coimbatore branches
SELECT branch_name
FROM BRANCH
WHERE assets > (
    SELECT MAX(assets)
    FROM BRANCH
    WHERE branch_city = 'Coimbatore'
);

-- v. PL/SQL to handle user-defined exception
DECLARE
    account_balance NUMBER;
    withdrawal_amount NUMBER := 10000;
    insufficient_balance EXCEPTION;
BEGIN
    SELECT balance INTO account_balance
    FROM ACCOUNT
    WHERE accno = 1001;

    IF account_balance < withdrawal_amount THEN
        RAISE insufficient_balance;
    ELSE
        UPDATE ACCOUNT
        SET balance = balance - withdrawal_amount
        WHERE accno = 1001;
        DBMS_OUTPUT.PUT_LINE('Withdrawal successful. New balance: ' || (account_balance - withdrawal_amount));
    END IF;
EXCEPTION
    WHEN insufficient_balance THEN
        DBMS_OUTPUT.PUT_LINE('Insufficient balance for withdrawal.');
END;
/
