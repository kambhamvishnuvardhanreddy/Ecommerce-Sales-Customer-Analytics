CREATE DATABASE Ecommerce_Analytics;
GO

USE Ecommerce_Analytics;
GO

CREATE TABLE Customers (
    Customer_ID VARCHAR(10) PRIMARY KEY,
    Customer_Name VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50),
    Region VARCHAR(20)
);

CREATE TABLE Products (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Unit_Price DECIMAL(12,2)
);

CREATE TABLE Orders (
    Order_ID VARCHAR(10) PRIMARY KEY,
    Order_Date DATE,
    Customer_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Quantity INT,
    Discount DECIMAL(5,2),
    Sales DECIMAL(12,2),
    Profit DECIMAL(12,2)
);

CREATE TABLE Payments (
    Payment_ID VARCHAR(10) PRIMARY KEY,
    Order_ID VARCHAR(10),
    Payment_Method VARCHAR(50),
    Payment_Status VARCHAR(20)
);
USE Ecommerce_Analytics;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

SELECT COUNT(*) AS Customer_Count FROM Customers;
SELECT COUNT(*) AS Product_Count FROM Products;
SELECT COUNT(*) AS Order_Count FROM Orders;
SELECT COUNT(*) AS Payment_Count FROM Payments;

SELECT COUNT(*) AS Customer_Count
FROM Customers_Import;

select * from Customers_import;

USE Ecommerce_Analytics;
GO

INSERT INTO Customers
(
    Customer_ID,
    Customer_Name,
    Gender,
    Age,
    City,
    State,
    Region
)
SELECT
    Customer_ID,
    Customer_Name,
    Gender,
    Age,
    City,
    State,
    Region
FROM Customers_Import;
GO

select top 10 * from Customers

USE Ecommerce_Analytics;
GO

INSERT INTO Products
(
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    Unit_Price
)
SELECT
    Product_ID,
    Product_Name,
    Category,
    Sub_Category,
    Unit_Price
FROM Products_Import;
GO
select * from Products_import

INSERT INTO Orders
(
    Order_ID,
    Order_Date,
    Customer_ID,
    Product_ID,
    Quantity,
    Discount,
    Sales,
    Profit
)
SELECT
    Order_ID,
    Order_Date,
    Customer_ID,
    Product_ID,
    Quantity,
    Discount,
    Sales,
    Profit
FROM Orders_Import;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders'
ORDER BY ORDINAL_POSITION;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders_Import'
ORDER BY ORDINAL_POSITION;


DROP TABLE Orders_Import;
GO

select * from Payments_import

INSERT INTO Payments
(
    Payment_ID,
    Order_ID,
    Payment_Method,
    Payment_Status
)
SELECT
    Payment_ID,
    Order_ID,
    Payment_Method,
    Payment_Status
FROM Payments_Import;

SELECT COUNT(*) AS Customers FROM Customers;
SELECT COUNT(*) AS Products FROM Products;
SELECT COUNT(*) AS Orders FROM Orders;
SELECT COUNT(*) AS Payments FROM Payments;

select SUM(sales) as Total_Sales from Orders;

select sum(profit) as Total_Profit from Orders;

select count(*) as Total_Orders from Orders;

select count(*) as Total_Customers from Customers;

SELECT
    P.Category,
    SUM(O.Sales) AS Total_Sales,
    SUM(O.Profit) AS Total_Profit
FROM Orders O
JOIN Products P
    ON O.Product_ID = P.Product_ID
GROUP BY P.Category
ORDER BY Total_Sales DESC;

SELECT TOP 10
    Product_ID,
    Sales
FROM Orders;

SELECT TOP 10
    Product_ID,
    Product_Name,
    Category
FROM Products;

SELECT COUNT(*) AS Matching_Products
FROM Orders O
INNER JOIN Products P
    ON O.Product_ID = P.Product_ID;

UPDATE Products
SET Product_ID = 'P' + RIGHT('000' + CAST(CAST(Product_ID AS INT) AS VARCHAR(3)), 3);

UPDATE Products
SET Product_ID = 'P' + RIGHT('000' + LEFT(Product_ID, CHARINDEX('.', Product_ID) - 1), 3);

SELECT COUNT(*) AS Matching_Products
FROM Orders O
INNER JOIN Products P
    ON O.Product_ID = P.Product_ID;

SELECT
    P.Category,
    SUM(O.Sales) AS Total_Sales,
    SUM(O.Profit) AS Total_Profit
FROM Orders O
JOIN Products P
    ON O.Product_ID = P.Product_ID
GROUP BY P.Category
ORDER BY Total_Sales DESC;

SELECT
    C.Region,
    SUM(O.Sales) AS Total_Sales,
    SUM(O.Profit) AS Total_Profit
FROM Orders O
JOIN Customers C
    ON O.Customer_ID = C.Customer_ID
GROUP BY C.Region
ORDER BY Total_Sales DESC;

SELECT TOP 10
    P.Product_ID,
    P.Product_Name,
    P.Category,
    SUM(O.Sales) AS Total_Sales
FROM Orders O
JOIN Products P
    ON O.Product_ID = P.Product_ID
GROUP BY
    P.Product_ID,
    P.Product_Name,
    P.Category
ORDER BY Total_Sales DESC;

SELECT TOP 10
    C.Customer_ID,
    C.Customer_Name,
    C.City,
    C.Region,
    SUM(O.Sales) AS Total_Sales
FROM Orders O
JOIN Customers C
    ON O.Customer_ID = C.Customer_ID
GROUP BY
    C.Customer_ID,
    C.Customer_Name,
    C.City,
    C.Region
ORDER BY Total_Sales DESC;

SELECT
    YEAR(Order_Date) AS Order_Year,
    MONTH(Order_Date) AS Order_Month,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Orders
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    Order_Year,
    Order_Month;

SELECT
    Payment_Status,
    COUNT(*) AS Total_Payments
FROM Payments
GROUP BY Payment_Status
ORDER BY Total_Payments DESC;

SELECT
    Payment_Method,
    COUNT(*) AS Total_Payments,
    SUM(CASE
        WHEN Payment_Status = 'Paid' THEN 1
        ELSE 0
    END) AS Successful_Payments
FROM Payments
GROUP BY Payment_Method
ORDER BY Total_Payments DESC;

SELECT
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS Average_Order_Value
FROM Orders;

SELECT TOP 10
    P.Product_ID,
    P.Product_Name,
    P.Category,
    SUM(O.Profit) AS Total_Profit
FROM Orders O
JOIN Products P
    ON O.Product_ID = P.Product_ID
GROUP BY
    P.Product_ID,
    P.Product_Name,
    P.Category
ORDER BY Total_Profit DESC;

SELECT
    C.Customer_ID,
    C.Customer_Name,
    COUNT(O.Order_ID) AS Total_Orders,
    SUM(O.Sales) AS Total_Sales
FROM Customers C
JOIN Orders O
    ON C.Customer_ID = O.Customer_ID
GROUP BY
    C.Customer_ID,
    C.Customer_Name
ORDER BY Total_Orders DESC;

SELECT
    C.Region,
    P.Category,
    SUM(O.Sales) AS Total_Sales,
    SUM(O.Profit) AS Total_Profit
FROM Orders O
JOIN Customers C
    ON O.Customer_ID = C.Customer_ID
JOIN Products P
    ON O.Product_ID = P.Product_ID
GROUP BY
    C.Region,
    P.Category
ORDER BY
    Total_Sales DESC;


SELECT @@SERVERNAME;

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%_Import';

DROP TABLE Customers_Import;
DROP TABLE Products_Import;
DROP TABLE Orders_Import;
DROP TABLE Payments_Import;