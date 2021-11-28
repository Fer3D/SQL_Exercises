/*Practice made with MySQL Workbench*/
DROP DATABASE  exercise;
CREATE DATABASE exercise;
USE exercise;

/*Create the tables.*/
CREATE TABLE departments (
	id_dep int PRIMARY KEY,
    description varchar(255) NOT NULL
);

CREATE TABLE employees (
	id_num int PRIMARY KEY,
    name varchar(255) NOT NULL,
    cat varchar(255) NOT NULL,
    salary int NOT NULL,
	id_dep int
);

CREATE TABLE products (
	id_pro int PRIMARY KEY,
    description varchar(255) NOT NULL,
    pvp int NOT NULL
);

CREATE TABLE sales (
	id_sales int PRIMARY KEY AUTO_INCREMENT,
	id_num int,
    id_pro int,
    cant int NOT NULL
);

/*Enter the given data.*/
ALTER TABLE employees ADD FOREIGN KEY (id_dep) REFERENCES departments(id_dep);
ALTER TABLE sales ADD FOREIGN KEY (id_num) REFERENCES employees(id_num);
ALTER TABLE sales ADD FOREIGN KEY (id_pro) REFERENCES products(id_pro);

INSERT INTO departments (id_dep, description)
VALUES (01, 'Servicios Centrales'), (02, 'Sucursal Madrid'), (03, 'Sucursal Toledo');

INSERT INTO employees (id_num, name, cat, salary)
VALUES (001, 'Javier Sanchez', 'Director', 250000), (002, 'Elena Gutiérrez', 'Secretary', 100000),
(003, 'Angel Hernández', 'Manager', 175000), (004, 'Rosa Anguiano', 'Commercial', 150000),
(005, 'Maria Bernal', 'Secretary', 90000), (006, 'Miguel Santamaría', 'Commercial', 150000);

INSERT INTO products (id_pro, description, pvp)
VALUES (01, 'DVD', 25000), (02, 'CPU', 120000), (03, 'Color Monitor 17"', 30000),
(04, 'Mouse', 1000), (05, 'Laser Printer', 110000);

INSERT INTO sales (id_num, id_pro, cant)
VALUES (003,01,2), (002,05,1), (004,02,3), (006,02,4), (006,03,7),
(004,05,4), (003,02,10), (002,03,2), (005,02,1);

/*Generate invoices in the form of a tuple of all products per screen.
Each invoice must contain:
- seller code
- product code
- unit price
- quantity sold
- tax base (price per units sold)
- applicable VAT rate (18% in all)
- total amount of the invoice corresponding to that seller (amount + VAT)*/
SELECT  e.id_num, p.id_pro, p.pvp, s.cant, p.pvp+(p.pvp*0.21) as 'Price with tax base', p.pvp+(p.pvp*0.18)
AS 'VAT 18%'
FROM employees e
INNER JOIN sales s ON e.id_num = s.id_num
INNER JOIN products p ON s.id_pro = p.id_pro;

/*Obtain the product code and number of times it has been sold, of the product that
on more occasions it has been sold.*/
SELECT id_pro, SUM(cant) AS 'Times it has been sold'
FROM sales
GROUP BY id_pro
ORDER BY SUM(cant) DESC
LIMIT 1;

/*Obtain the name and professional category of those employees who have obtained
more income in sales than any Commercial.*/
SELECT name, cat AS 'Job', sum(pvp) AS 'Earnings'
FROM employees
INNER JOIN sales ON employees.id_num = sales.id_num
INNER JOIN products ON products.id_pro = sales.id_num
WHERE cat > 'Commercial'
GROUP BY name;

/*Raise by 5% the salary of employees who have sold more units than those
products with a price greater than 50,000.*/
UPDATE employees e 
INNER JOIN sales v ON e.id_num = v.id_num
INNER JOIN products p ON v.id_pro = p.id_pro
SET e.salary = e.salary + e.salary*0.1
WHERE e.salary > v.cant*p.pvp > 50000;

/*Delete from the 'Toledo Branch' department.*/
DELETE FROM departments WHERE description='Sucursal Toledo';

/*Eliminate the contents and structures of the tables.*/
DROP TABLE employees, departments, products, sales;