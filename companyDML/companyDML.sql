-- File: companyDML-a-solution 
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance; it is provided for your convenience when checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
** Run this file (from the command line in sqlplus).
** Print the resulting spooled file (companyDML-a.out) and submit the printout in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However, you ***MUST*** run this file from the command line as just explained above and then submit a printout of the spooled file. Submitting a printout of the webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-a.out
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: Kasey Stowell
--
-- ------------------------------------------------------------
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10A)
Find the ssn and last name of every employee who doesn't have a  supervisor, or his last name contains at least two occurences of the letter 'a'. Sort the results by ssn.
*/
SELECT E.ssn, E.lname
FROM employee E
WHERE E.super_ssn IS NULL OR E.lname LIKE '%a%a%'
ORDER BY E.ssn DESC;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11A)
For every employee who works more than 30 hours on any project: Find the ssn, lname, project number, project name, and numer of hours. Sort the results by ssn.
*/
SELECT W.essn, E.lname, W.pno, P.pname, W.hours
FROM works_on W, employee E, project P
WHERE W.essn = E.ssn AND W.pno = P.pnumber AND W.Hours > 30
ORDER BY W.Essn DESC;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12A)
Write a query that consists of one block only.
For every employee who works on a project that is not controlled by the department he works for: Find the employee's lname, the department he works for, the project number that he works on, and the number of the department that controls that project. Sort the results by lname.
*/
SELECT E.lname, E.dno, P.pnumber, P.dnum
FROM employee E, project P, works_on W
WHERE E.ssn = W.essn AND P.pnumber = W.pno AND E.dno != P.dnum
ORDER BY E.lname ASC;
--
-- JOINING 4 TABLES -------------------------
--
/*(13A)
For every employee who works for more than 20 hours on any project that is located in the same location as his department: Find the ssn, lname, project number, project location, department number, and department location.Sort the results by lname
*/
SELECT E.ssn, E.lname, P.pnumber, P.plocation, D.dnumber, D.dlocation
FROM employee E, works_on W, project P, dept_locations D
WHERE E.ssn = W.essn AND P.pnumber = W.pno AND P.plocation = D.dlocation AND E.dno = P.dnum AND W.hours > 20
ORDER BY E.lname ASC;
--
-- SELF JOIN -------------------------------------------
-- 
/*(14A)
Write a query that consists of one block only.
For every employee whose salary is less than 70% of his immediate supervisor's salary: Find his ssn, lname, salary; and his supervisor's ssn, lname, and salary. Sort the results by ssn.  
*/
SELECT E1.ssn, E1.lname, E1.salary, E2.ssn, E2.lname, E2.salary
FROM employee E1, employee E2
WHERE E2.ssn = E1.super_ssn AND (E1.salary < (E2.salary * .7))
ORDER BY E1.ssn ASC;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15A)
For projects located in Houston: Find pairs of last names such that the two employees in the pair work on the same project. Remove duplicates. Sort the result by the lname in the left column in the result. 
*/
SELECT E1.lname, E2.lname
FROM employee E1, employee E2, project P, works_on W1, works_on W2
WHERE P.plocation = 'Houston' AND E1.ssn = W1.essn AND E2.ssn = W2.essn AND W1.pno = W2.pno AND W1.pno = P.pnumber AND E1.ssn < E2.ssn
ORDER BY E1.lname ASC;
--
------------------------------------
--
/*(16A) Hint: A NULL in the hours column should be considered as zero hours.
Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
*/ 
SELECT E.ssn, E.lname, NVL(SUM(W.hours), 0) AS hours
FROM employee E, works_on W
WHERE E.ssn = W.essn
GROUP BY E.ssn, E.lname
HAVING NVL(SUM(W.hours), 0) < 40
ORDER BY E.lname ASC;
--
------------------------------------
-- 
/*(17A)
For every project that has more than 2 employees working on it: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/ 
SELECT P.pnumber, P.pname, COUNT(*) AS employees, SUM(W.hours) AS hours
FROM project P, works_on W
WHERE W.pno = P.pnumber
GROUP BY P.pnumber, P.pname
HAVING COUNT(*) > 2
ORDER BY P.pnumber ASC;
-- 
-- CORRELATED SUBQUERY --------------------------------
--
/*(18A)
For every employee who has the highest salary in his department: Find the dno, ssn, lname, and salary . Sort the results by department number.
*/
SELECT E1.dno, E1.ssn, E1.lname, E1.salary
FROM employee E1
WHERE NOT EXISTS (SELECT E2.ssn FROM employee E2 WHERE E1.dno = E2.dno AND E1.salary < E2.salary)
ORDER BY E1.dno ASC;
--
-- NON-CORRELATED SUBQUERY -------------------------------
--
/*(19A)
For every employee who does not work on any project that is located in Houston: Find the ssn and lname. Sort the results by lname
*/
SELECT E.ssn, E.lname
FROM employee E
WHERE E.ssn NOT IN (SELECT W.essn FROM project P, works_on W WHERE P.plocation = 'Houston' AND P.pnumber = W.pno)
ORDER BY E.lname ASC;
--
-- DIVISION ---------------------------------------------
--
/*(20A) Hint: This is a DIVISION query
For every employee who works on every project that is located in Stafford: Find the ssn and lname. Sort the results by lname
*/
SELECT E.ssn, E.lname
FROM employee E
WHERE NOT EXISTS ((SELECT P.pnumber FROM project P WHERE P.plocation = 'Stafford') MINUS (SELECT P.pnumber FROM works_on W, project P WHERE E.ssn = W.essn AND P.plocation = 'Stafford' AND W.pno = P.pnumber))
ORDER BY E.lname ASC;
--
SET ECHO OFF
SPOOL OFF


