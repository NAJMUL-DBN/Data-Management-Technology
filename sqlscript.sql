REM   Script: Tutorial-03
REM   University class 

CREATE TABLE OrderTable ( 
    OrderID INT PRIMARY KEY, 
    CustomerID INT, 
    OrderDate DATE 
);

CREATE TABLE Customer ( 
    CustomerID INT PRIMARY KEY, 
    CustomerName VARCHAR(100), 
    ContactName VARCHAR(100), 
    Country VARCHAR(50) 
);

CREATE TABLE lives ( 
    person_name VARCHAR(100), 
    street VARCHAR(100), 
    city VARCHAR(50), 
    PRIMARY KEY (person_name) 
);

CREATE TABLE works ( 
    person_name VARCHAR(100), 
    company_name VARCHAR(100), 
    salary INT, 
    PRIMARY KEY (person_name), 
    FOREIGN KEY (person_name) REFERENCES lives(person_name) 
);

CREATE TABLE located_in ( 
    company_name VARCHAR(100), 
    city VARCHAR(50), 
    PRIMARY KEY (company_name) 
);

CREATE TABLE manages ( 
    person_name VARCHAR(100), 
    manager_name VARCHAR(100), 
    PRIMARY KEY (person_name), 
    FOREIGN KEY (manager_name) REFERENCES lives(person_name) 
);

CREATE TABLE employees ( 
    employee_id INT PRIMARY KEY, 
    last_name VARCHAR(100), 
    job_id VARCHAR(50), 
    hire_date DATE, 
    salary DECIMAL(10,2), 
    department_id INT, 
    manager_id INT 
);

INSERT INTO Customer VALUES (2, 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Mexico');

INSERT INTO Customer VALUES (1, 'Alfreds Futterkiste', 'Maria Anders', 'Germany');

INSERT INTO Customer VALUES (3, 'Antonio Moreno Taquería', 'Antonio Moreno', 'Mexico');

INSERT INTO Customer VALUES (2, 'Ana Trujillo Emparedados y helados', 'Ana Trujillo', 'Mexico');

INSERT INTO works VALUES ('John Doe', 'Acme', 50000);

INSERT INTO works VALUES ('Alice Johnson', 'Gamma Inc', 70000);

INSERT INTO OrderTable VALUES (10308, 2, '1996-09-18');

INSERT INTO OrderTable VALUES (10310, 77, '1996-09-20');

INSERT INTO lives VALUES ('John Doe', '123 Elm St', 'XYZ');

INSERT INTO lives VALUES ('Jane Smith', '456 Oak St', 'ABC');

INSERT INTO lives VALUES ('Alice Johnson', '789 Pine St', 'XYZ');

INSERT INTO employees VALUES (101, 'Smith', 'IT_PROG', '2005-06-01', 12000, 20, 201);

INSERT INTO employees VALUES (102, 'Johnson', 'HR_REP', '2008-09-15', 8000, 50, 202);

INSERT INTO OrderTable VALUES (10308, 2, '1996-09-18');

INSERT INTO OrderTable VALUES (10310, 77, TO_DATE('1996-09-20', 'YYYY-MM-DD'));

INSERT INTO lives VALUES ('John Doe', '123 Elm St', 'XYZ');

INSERT INTO OrderTable VALUES (10308, 2, TO_DATE('1996-09-18', 'YYYY-MM-DD'));

INSERT INTO OrderTable VALUES (10309, 37, TO_DATE('1996-09-19', 'YYYY-MM-DD'));

INSERT INTO lives VALUES ('Jane Smith', '456 Oak St', 'ABC');

INSERT INTO lives VALUES ('Alice Johnson', '789 Pine St', 'XYZ');

INSERT INTO employees VALUES (101, 'Smith', 'IT_PROG', TO_DATE('2005-06-01', 'YYYY-MM-DD'), 12000, 20, 201);

INSERT INTO employees VALUES (102, 'Johnson', 'HR_REP', TO_DATE('2008-09-15', 'YYYY-MM-DD'), 8000, 50, 202);

INSERT INTO employees VALUES (103, 'Williams', 'SA_MAN', TO_DATE('2010-12-10', 'YYYY-MM-DD'), 15000, 30, 203);

INSERT INTO manages VALUES ('John Doe', 'Alice Johnson');

INSERT INTO manages VALUES ('Jane Smith', 'John Doe');

INSERT INTO manages VALUES ('Alice Johnson', 'Jane Smith');

INSERT INTO located_in VALUES ('Acme', 'XYZ');

INSERT INTO located_in VALUES ('BetaCorp', 'ABC');

INSERT INTO works VALUES ('John Doe', 'Acme', 50000);

INSERT INTO works VALUES ('Jane Smith', 'BetaCorp', 60000);

INSERT INTO lives VALUES ('John Doe', '123 Elm St', 'XYZ');

INSERT INTO lives VALUES ('Alice Johnson', '789 Pine St', 'XYZ');

SELECT DISTINCT job_id FROM employees;

SELECT last_name, salary FROM employees WHERE salary > 12000;

SELECT employee_id, last_name, job_id, hire_date FROM employees;

SELECT last_name AS Employee, salary AS "Monthly Salary" FROM employees WHERE salary BETWEEN 5000 AND 12000 AND department_id IN (20, 50);

SELECT last_name, CEIL(MONTHS_BETWEEN(SYSDATE, hire_date)) AS months_worked FROM employees;

SELECT last_name, department_id FROM employees WHERE department_id IN (20, 30, 50) ORDER BY last_name ASC;

SELECT last_name, department_id FROM employees WHERE department_id IN (20, 50) ORDER BY last_name ASC;

SELECT last_name, hire_date FROM employees WHERE EXTRACT(YEAR FROM hire_date) = 2005;

SELECT last_name, salary FROM employees WHERE salary > :user_input;

SELECT employee_id, last_name, salary, department_id FROM employees WHERE manager_id = :manager_id;

SELECT MIN(salary) AS min_salary, MAX(salary) AS max_salary FROM employees;

