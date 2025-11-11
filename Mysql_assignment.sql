## Question 6: 
create database ECommerceDB;
use ECommerceDB;
create table categories (
categoryID  INT PRIMARY KEY,
categoryname varchar(50) not null unique); 
create table Products (
productID int primary key,
ProductName VARCHAR(100) NOT NULL UNIQUE,
CategoryID INT,
FOREIGN KEY(categoryid) references categories(categoryid),
Price DECIMAL(10,2) NOT NULL,
StockQuantity INT );
create table Customers (
CustomerID INT PRIMARY KEY,
CustomerName VARCHAR(100) NOT NULL,
 Email VARCHAR(100) UNIQUE, 
 JoinDate DATE );
create table Orders ( 
OrderID INT PRIMARY KEY,
CustomerID INT, FOREIGN KEY(customerid) references customers(customerid),
OrderDate DATE NOT NULL, 
TotalAmount DECIMAL(10,2));
insert into categories value
(1, 'Electronics'),
(2, 'Books'),
(3, 'Home Goods'),
(4, 'Apparel');
insert into  products values
(101, 'Laptop Pro', 1, 1200.00, 50),
(102, 'SQL Handbook', 2, 45.50, 200),
(103, 'Smart Speaker', 1, 99.99, 150),
(104, 'Coffee Maker', 3, 75.00, 80),
(105, 'Novel: The Great SQL', 2, 25.00, 120),
(106, 'Wireless Earbuds', 1, 150.00, 100),
(107, 'Blender X', 3, 120.00, 60),
(108, 'T-Shirt Casual', 4, 20.00, 300);
insert into customers values
(1, 'Alice Wonderland', 'alice@example.com', '2023-01-10'),
(2, 'Bob the Builder', 'bob@example.com', '2022-11-25'),
(3, 'Charlie Chaplin', 'charlie@example.com', '2023-03-01'),
(4, 'Diana Prince', 'diana@example.com', '2021-04-26');
insert into orders values
(1001, 1, '2023-04-26', 1245.50),
(1002, 2, '2023-10-12', 99.99),
(1003, 1, '2023-07-01', 145.00),
(1004, 3, '2023-01-14', 150.00),
(1005, 2, '2023-09-24', 120.00),
(1006, 1, '2023-06-19', 20.00);
select* from products;
select* from customers;
select* from orders;
select* from categories;
# Question 7
select c.customername , c.email ,
count(o.orderid) as totalnumberoforders
from customers c
left join orders o on c.customerid = o.customerid
group by c.customername , c.email
order by c.customername;
# Question 8
select  p.ProductName, p.Price, p.StockQuantity, c.CategoryName
from products p
join catrgories c on p.categoryid = c.categoryid
order by c.categoryname , p.productname;
# Question 9
with rankedproduct as( 
select c.categoryname , p.productname , p.price,
row_number() over (PARTITION BY c.CategoryName ORDER BY p.Price DESC) AS RankNum
    FROM Products p
    JOIN Categories c ON p.CategoryID = c.CategoryID
)
SELECT CategoryName, ProductName, Price
FROM RankedProducts
WHERE RankNum <= 2;
# Question 10
use sakila;
# Top 5 customers by total amount spent
SELECT c.first_name, c.last_name, c.email, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;
# Top 3 movie categories by rental count
SELECT cat.name AS CategoryName, COUNT(r.rental_id) AS RentalCount
FROM category cat
JOIN film_category fc ON cat.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY cat.name
ORDER BY RentalCount DESC
LIMIT 3;
# Films available at each store and never rented
SELECT s.store_id,
       COUNT(i.inventory_id) AS TotalFilms,
       SUM(CASE WHEN r.rental_id IS NULL THEN 1 ELSE 0 END) AS NeverRented
FROM store s
JOIN inventory i ON s.store_id = i.store_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY s.store_id;
# Total revenue per month for 2023
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS Month, SUM(amount) AS TotalRevenue
FROM payment
WHERE YEAR(payment_date) = 2023
GROUP BY Month
ORDER BY Month;
# Customers who rented more than 10 times in last 6 months
SELECT c.first_name, c.last_name, COUNT(r.rental_id) AS RentalCount
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.customer_id
HAVING COUNT(r.rental_id) > 10;