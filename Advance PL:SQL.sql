-- ============================================================================
-- PL/SQL ADVANCED I - All Exercises in One Script
-- HR Database Required
-- ============================================================================

SET SERVEROUTPUT ON;
SET VERIFY OFF;
SET ECHO OFF;

-- ============================================================================
-- Exercise 1: Record DataType
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Exercise 1: Record DataType ---');
END;
/

DECLARE
    v_country_id VARCHAR2(2) := 'CA';
    v_rec hr.countries%ROWTYPE;
BEGIN
    SELECT * INTO v_rec FROM hr.countries WHERE country_id = v_country_id;
    DBMS_OUTPUT.PUT_LINE('Country ID: ' || v_rec.country_id ||
                         ', Country Name: ' || v_rec.country_name ||
                         ', Region: ' || v_rec.region_id);
END;
/

-- ============================================================================
-- Exercise 2: Table DataType with Loops
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Exercise 2: Table DataType with Loops ---');
END;
/

DECLARE
    TYPE Dept_Table_Type IS TABLE OF hr.departments%ROWTYPE INDEX BY PLS_INTEGER;
    v_dept_table Dept_Table_Type;
    n INTEGER := 0;
BEGIN
    FOR dept IN (SELECT * FROM hr.departments) LOOP
        n := n + 1;
        v_dept_table(n) := dept;
    END LOOP;

    n := v_dept_table.FIRST;
    WHILE n IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(v_dept_table(n).department_name);
        n := v_dept_table.NEXT(n);
    END LOOP;
END;
/

-- ============================================================================
-- Exercise 3: Explicit Cursor
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Exercise 3: Explicit Cursor ---');
END;
/

DECLARE
    v_empid hr.employees.employee_id%TYPE;
    v_empname hr.employees.first_name%TYPE;
    v_salary hr.employees.salary%TYPE;

    CURSOR employee_cursor IS
        SELECT employee_id, first_name, salary FROM hr.employees;
BEGIN
    OPEN employee_cursor;
    LOOP
        FETCH employee_cursor INTO v_empid, v_empname, v_salary;
        EXIT WHEN employee_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_empid || ' ' || v_empname || ' ' || v_salary);
    END LOOP;
    CLOSE employee_cursor;
END;
/

-- ============================================================================
-- Exercise 4: Cursor with FOR Loop
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Exercise 4: Cursor with FOR Loop ---');
END;
/

DECLARE
    v_empid hr.employees.employee_id%TYPE;
    v_empname hr.employees.first_name%TYPE;
    v_salary hr.employees.salary%TYPE;

    CURSOR employee_cursor IS
        SELECT employee_id, first_name, salary FROM hr.employees;
BEGIN
    FOR emp IN employee_cursor LOOP
        v_empid := emp.employee_id;
        v_empname := emp.first_name;
        v_salary := emp.salary;

        DBMS_OUTPUT.PUT_LINE(v_empid || ' ' || v_empname || ' ' || v_salary);
    END LOOP;
END;
/

-- ============================================================================
-- Exercise 5A: Cursor With Conditionals
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Exercise 5A: Conditional Raise Check ---');
END;
/

DECLARE
    v_deptno NUMBER := 10;
    CURSOR c_emp_cursor IS
        SELECT last_name, salary, manager_id
        FROM employees
        WHERE department_id = v_deptno;
BEGIN
    FOR emp_record IN c_emp_cursor LOOP
        IF emp_record.salary < 5000 AND (emp_record.manager_id = 101 OR emp_record.manager_id = 124) THEN
            DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' Due for a raise');
        ELSE
            DBMS_OUTPUT.PUT_LINE(emp_record.last_name || ' Not Due for a raise');
        END IF;
    END LOOP;
END;
/

-- ============================================================================
-- Exercise 5B: Two Cursors (One Parametrized)
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Exercise 5B: Two Cursors with Parameter ---');
END;
/

DECLARE
    CURSOR c_dept_cursor IS
        SELECT department_id, department_name
        FROM departments
        WHERE department_id < 100
        ORDER BY department_id;

    CURSOR c_emp_cursor(v_deptno NUMBER) IS
        SELECT last_name, job_id, hire_date, salary
        FROM employees
        WHERE department_id = v_deptno AND employee_id < 120;

    v_current_deptno departments.department_id%TYPE;
    v_current_dname  departments.department_name%TYPE;
    v_ename          employees.last_name%TYPE;
    v_job            employees.job_id%TYPE;
    v_hiredate       employees.hire_date%TYPE;
    v_sal            employees.salary%TYPE;
BEGIN
    OPEN c_dept_cursor;
    LOOP
        FETCH c_dept_cursor INTO v_current_deptno, v_current_dname;
        EXIT WHEN c_dept_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Department Number : ' || v_current_deptno ||
                             ' Department Name : ' || v_current_dname);

        OPEN c_emp_cursor(v_current_deptno);
        LOOP
            FETCH c_emp_cursor INTO v_ename, v_job, v_hiredate, v_sal;
            EXIT WHEN c_emp_cursor%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(v_ename || ' ' || v_job || ' ' || v_hiredate || ' ' || v_sal);
        END LOOP;
        CLOSE c_emp_cursor;

        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
    END LOOP;
    CLOSE c_dept_cursor;
END;
/

-- ============================================================================
-- Exercise 6: Exception Handling
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Exercise 6: Exception Handling ---');
END;
/

-- Drop & recreate messages table
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE messages';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE messages (results VARCHAR2(80));

-- Block 1: Try salary = 6000
DECLARE
    v_ename employees.last_name%TYPE;
    v_emp_sal employees.salary%TYPE := 6000;
BEGIN
    SELECT last_name INTO v_ename
    FROM employees
    WHERE salary = v_emp_sal;

    INSERT INTO messages (results)
    VALUES (v_ename || ' - ' || v_emp_sal);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO messages (results)
        VALUES ('No employee with a salary of ' || TO_CHAR(v_emp_sal));
    WHEN TOO_MANY_ROWS THEN
        INSERT INTO messages (results)
        VALUES ('More than one employee with a salary of ' || TO_CHAR(v_emp_sal));
    WHEN OTHERS THEN
        INSERT INTO messages (results)
        VALUES ('Some other error occurred.');
END;
/

-- Block 2: Try salary = 2000
DECLARE
    v_ename employees.last_name%TYPE;
    v_emp_sal employees.salary%TYPE := 2000;
BEGIN
    SELECT last_name INTO v_ename
    FROM employees
    WHERE salary = v_emp_sal;

    INSERT INTO messages (results)
    VALUES (v_ename || ' - ' || v_emp_sal);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO messages (results)
        VALUES ('No employee with a salary of ' || TO_CHAR(v_emp_sal));
    WHEN TOO_MANY_ROWS THEN
        INSERT INTO messages (results)
        VALUES ('More than one employee with a salary of ' || TO_CHAR(v_emp_sal));
    WHEN OTHERS THEN
        INSERT INTO messages (results)
        VALUES ('Some other error occurred.');
END;
/

-- Display Messages Table
SELECT * FROM messages;