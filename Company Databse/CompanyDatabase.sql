
--I HAVE FORGOTTEN TO ADD 107 EMP_ID AND OTHER DETAILS SO DONT BOTHER IF YOU FCAE ANY DIFFICLUTY RELATING TO 107
CREATE TABLE emp(
    emp_id  INT PRIMARY KEY,
    first_name VARCHAR(10),
    second_name VARCHAR(10),
    DOB DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT, 
    branch_id INT  
);

--SUPER_ID AND BRANCH_ID ARE THE FOREIGN KEYS WHICH POINTS TO EMPLOYEE AND BRANCH RESPECTIVELY 

CREATE TABLE BRANCH(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(10),
    mngr_id INT,
    mngr_start_date DATE,
    FOREIGN KEY(mngr_id) REFERENCES emp(emp_id) ON DELETE SET NULL
);

ALTER TABLE emp
ADD FOREIGN KEY(branch_id)
REFERENCES BRANCH(branch_id)
ON DELETE SET NULL;

ALTER TABLE emp
ADD FOREIGN KEY emp(super_id)
REFERENCES emp(emp_id)
ON DELETE SET NULL;

CREATE TABLE Client_Table(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(20),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id) ON DELETE SET NULL 
);

DROP TABLE works_with;

CREATE TABLE works_with(
    emp_id INT ,
    client_id INT,
    total_sales INT,
    FOREIGN KEY (emp_id) REFERENCES emp(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES Client_Table(client_id) ON DELETE CASCADE
);

 CREATE TABLE BRANCH_SUPPLIER(
     branch_id INT,
     supplier_name VARCHAR(20),
     supplier_type VARCHAR(15),
     FOREIGN KEY (branch_id) REFERENCES BRANCH(branch_id) ON DELETE CASCADE
 );

--What is done till now :-
--1-TABLES = emp , BRANCH , Client_Table , works_with , BRANCH_SUPPLIER

--Beginning inserting values in BRANCH 

INSERT INTO emp VALUES(100,'David','Wallace','1939-11-17','M',250000,NULL,NULL);
INSERT INTO BRANCH VALUES(1,'Corporate',100,'2006-02-09');

UPDATE emp
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO emp VALUES(101,'Jan','Levinson','1961-05-11','F',110000,100,1);

--Till now we have inserted our employees in emp and BRANCH of branch_id =1

--Beginning Inserting in emp and BRANCH with branhc_id = 2

INSERT INTO emp VALUES(102,'Michael','Scott','1964-03-15','M',75000,100,NULL);
INSERT INTO BRANCH VALUES(2,'Scranton',102,'1992-04-06');

UPDATE emp
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO emp VALUES(103,'Angela','Martin','1971-06-05','F',63000,102,2);
INSERT INTO emp VALUES(104,'Kelly','Kapoor','1980-02-25','F',55000,102,2);
INSERT INTO emp VALUES(105,'Stanley','Hudson','1958-02-19','M',69000,102,2);

--Beginning Inserting into emp and BANCH with branch_id =3
INSERT INTO emp VALUES(106,'Josh','Porter','1969-09-05','M',78000,100,NULL);
INSERT INTO BRANCH VALUES(3,'Stanford',106,'1998-02-13');  

UPDATE emp
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO emp VALUES(107,'Andy','Bernanrd','1973-07-22','M',65000,106,3);
INSERT INTO emp VALUES(108,'Jim','Halpert','1978-10-01','M',71000,106,3);

SELECT * FROM emp;
SELECT * FROM BRANCH;

--bEGINNING iNSERTING INTO BRANCH_SUPPLIER TABLE
INSERT INTO BRANCH_SUPPLIER VALUES(2,'Hammer Mill','Paper');
INSERT INTO BRANCH_SUPPLIER VALUES(2,'Uni-Ball','Writing Utens');
INSERT INTO BRANCH_SUPPLIER VALUES(3,'Patriot Paper','Paper');
INSERT INTO BRANCH_SUPPLIER VALUES(2,'J.T Forms and Labels','Custom Forms');
INSERT INTO BRANCH_SUPPLIER VALUES(3,'Uni-Ball','Writing Utens');
INSERT INTO BRANCH_SUPPLIER VALUES(3,'Hammer Mill','Paper');
INSERT INTO BRANCH_SUPPLIER VALUES(3,'Stanford Labels','Custom Forms');

SELECT * FROM BRANCH_SUPPLIER;

--Beginning Inserting into Client_Table
INSERT INTO Client_Table VALUES(400,'Dunmore HS',2);
INSERT INTO Client_Table VALUES(401,'L&C',2);
INSERT INTO Client_Table VALUES(402,'FedEx',3);
INSERT INTO Client_Table VALUES(403,'JDL LLC',3);
INSERT INTO Client_Table VALUES(404,'Scranton PGs',2);
INSERT INTO Client_Table VALUES(405,'Times NP',3);
INSERT INTO Client_Table VALUES(406,'FedEx',2);

SELECT * FROM Client_Table;

--Beginning Inserting into works_with table
INSERT INTO works_with VALUES(105,400,55000);
INSERT INTO works_with VALUES(102,401,267000);
INSERT INTO works_with VALUES(108,402,22500);
INSERT INTO works_with VALUES(107,403,5000);
INSERT INTO works_with VALUES(108,403,12000);
INSERT INTO works_with VALUES(105,404,33000);
INSERT INTO works_with VALUES(107,405,26000);
INSERT INTO works_with VALUES(102,406,15000);
INSERT INTO works_with VALUES(105,406,130000);

SELECT * FROM works_with;

-- More basics------------------------------------------------

SELECT * FROM emp;
SELECT * FROM Client_Table;

SELECT * FROM emp
ORDER BY salary;

SELECT * FROM emp
ORDER  BY salary DESC;

SELECT * FROM emp
ORDER BY sex,first_name,second_name;
--This was to order them by sex then first_name and then by second_name

SELECT * FROM emp
LIMIT 5; 
--This will show only first five employees of the emp table

SELECT  first_name,second_name FROM emp;


SELECT DISTINCT sex FROM emp;

SELECT DISTINCT branch_id FROM emp;


--FUNCTIONS--------------------------------------

SELECT COUNT(emp_id) FROM emp;

SELECT COUNT(super_id) FROM emp;
--THIS WILL DISPAY 7 BECAUSE 100 HAS NO SUPER ID/ SUPER ID IS NULL

SELECT COUNT(emp_id) FROM emp
WHERE sex ='F' AND DOB > '1970-01-01';

SELECT AVG(salary) FROM emp
WHERE sex = 'M';
---AVG IS TO FIND OUT AVERAGE

SELECT SUM(salary) FROM emp
WHERE sex = 'M';


--********--
SELECT COUNT(sex) , sex
FROM emp
GROUP BY sex;

SELECT SUM(total_sales) , emp_id 
FROM works_with
GROUP BY emp_id;

SELECT SUM(total_sales) , client_id
FROM works_with
GROUP BY client_id;

--*****----
--WILDCARDS--
--*****----
-- % ANY NUMBER OF CHAR   AND   _ MEANS ONE CHAR

SELECT * FROM Client_Table
WHERE client_name LIKE '%LLC';

SELECT * FROM BRANCH_SUPPLIER
WHERE supplier_name LIKE '%LABELS';

SELECT * FROM emp
WHERE DOB LIKE '____-10%';

SELECT * FROM Client_Table
WHERE client_name LIKE '%S';

---*****----
---UNIONS----
--SAME NO. OF COLUMNS
--SIMILAR DATA TYPES
SELECT first_name AS COMPLETE_LIST
FROM emp
UNION
SELECT branch_name 
FROM BRANCH
UNION
SELECT client_name 
FROM Client_Table;

SELECT client_name AS NAAM , branch_id FROM Client_Table
UNION
SELECT supplier_name , branch_id FROM BRANCH_SUPPLIER;

--******--
--JOINS--
--*****--
SELECT emp.emp_id , emp.first_name ,BRANCH.branch_name
FROM emp
JOIN BRANCH
ON emp_id = mngr_id;

--LEFT JOIN
INSERT INTO BRANCH VALUES(4,'BJP',NULL,NULL);

SELECT emp.emp_id , emp.first_name ,BRANCH.branch_name FROM emp LEFT JOIN BRANCH ON emp_id = mngr_id;

--RIGHT JOIN
SELECT emp.emp_id , emp.first_name , BRANCH.branch_name FROM emp RIGHT JOIN BRANCH ON emp_id = mngr_id;

--*******--
--NESTED QUERIES--
SELECT emp_id FROM works_with WHERE total_sales > 30000;

SELECT first_name , second_name FROM emp WHERE emp_id IN (
    SELECT emp_id FROM works_with WHERE total_sales > 30000
);
--READ THESE QUERIES FROM DOWNWARDS TO UPWARD (LAST EXAMPLE)

SELECT client_name FROM Client_Table WHERE branch_id IN (
    SELECT branch_id FROM BRANCH WHERE mngr_id = 102 LIMIT 1 
);

--****************************--
-------ON DELETE------------------
--ON DELETE SET NULL / SET THAT PARTICULAR VALUE TO NULL
SELECT * FROM BRANCH;

DELETE FROM emp WHERE emp_id = 102;

SELECT * FROM BRANCH; 

SELECT * FROM emp;

--ON DELETE CASCADE / DELETES THE ENTIRE ROW
SELECT * FROM BRANCH_SUPPLIER;

DELETE FROM BRANCH_SUPPLIER WHERE branch_id = 2;
