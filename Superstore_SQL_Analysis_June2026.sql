CREATE DATABASE superstore_db;
USE superstore_db;

CREATE TABLE orders (
    Row_ID INT,
    Order_ID VARCHAR(50),
    Order_Date VARCHAR(50),  
    Ship_Date VARCHAR(50),
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(50),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name TEXT,
    Sales DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(4,2),
    Profit DECIMAL(10,2)
);
UPDATE orders 
SET Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%Y'),
    Ship_Date = STR_TO_DATE(Ship_Date, '%m/%d/%Y');
    
    
ALTER TABLE orders 
MODIFY Order_Date DATE,
MODIFY Ship_Date DATE;

ALTER TABLE orders ADD COLUMN Delivery_Time INT;

UPDATE orders SET Delivery_Time = DATEDIFF(Ship_Date, Order_Date);

SELECT 
    Order_ID,
    DATE_FORMAT(Order_Date, '%d/%m/%Y') AS Order_Date,
    DATE_FORMAT(Ship_Date, '%d/%m/%Y') AS Ship_Date,
    Delivery_Time,
    Category
FROM orders 
ORDER BY Order_Date DESC
LIMIT 5;

SET SQL_SAFE_UPDATES = 0; -- Turns off safety lock

UPDATE orders 
SET Order_Date = STR_TO_DATE(Order_Date, '%m/%d/%Y'),
    Ship_Date = STR_TO_DATE(Ship_Date, '%m/%d/%Y');
    
    ALTER TABLE orders 
MODIFY Order_Date DATE,
MODIFY Ship_Date DATE;

ALTER TABLE orders ADD COLUMN Delivery_Time INT;


UPDATE orders SET Delivery_Time = DATEDIFF(Ship_Date, Order_Date);

SET SQL_SAFE_UPDATES = 1;

SELECT 
    Order_ID,
    DATE_FORMAT(Order_Date, '%d/%m/%Y') AS Order_Date,
    DATE_FORMAT(Ship_Date, '%d/%m/%Y') AS Ship_Date,
    Delivery_Time
FROM orders 
ORDER BY Order_Date DESC
LIMIT 5;

SET SQL_SAFE_UPDATES = 0; 
UPDATE orders SET Delivery_Time = DATEDIFF(Ship_Date, Order_Date);
SET SQL_SAFE_UPDATES = 1;

    
    ALTER TABLE orders 
MODIFY Order_Date DATE,
MODIFY Ship_Date DATE;


SELECT Order_Date, Ship_Date, DATEDIFF(Ship_Date, Order_Date) AS test_diff 
FROM orders 
LIMIT 5;

SELECT 
    Order_ID,
    DATE_FORMAT(Order_Date, '%d/%m/%Y') AS Order_Date,
    DATE_FORMAT(Ship_Date, '%d/%m/%Y') AS Ship_Date,
    Delivery_Time
FROM orders 
ORDER BY Order_Date DESC
LIMIT 5;

SELECT 
    ROUND(AVG(Delivery_Time), 1) AS Avg_Delivery_Days,
    MIN(Delivery_Time) AS Fastest_Delivery,
    MAX(Delivery_Time) AS Slowest_Delivery
FROM orders;

SELECT 
    Ship_Mode,
    ROUND(AVG(Delivery_Time), 1) AS Avg_Days,
    COUNT(*) AS Total_Orders
FROM orders 
GROUP BY Ship_Mode 
ORDER BY Avg_Days;

SELECT 
    Region,
    ROUND(AVG(Delivery_Time), 1) AS Avg_Days,
    COUNT(*) AS Orders
FROM orders 
GROUP BY Region 
ORDER BY Avg_Days DESC;

-- 1)Most Frequent Product Name We Sold
SELECT Product_Name, COUNT(*) AS Times_Sold
FROM orders
GROUP BY Product_Name
ORDER BY Times_Sold DESC
LIMIT 1;

-- 2)Most Region, State and City Ordered
SELECT Region, State, City, COUNT(*) AS Total_Orders
FROM orders
GROUP BY Region, State, City
ORDER BY Total_Orders DESC
LIMIT 1;

-- 3)Most Discounts Given To Customers
SELECT Customer_Name, ROUND(SUM(Discount * Sales), 0) AS Total_Discount_Given
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Discount_Given DESC
LIMIT 1;

-- 4)Most Sold Category & Sub-Category
SELECT Category, Sub_Category, COUNT(*) AS Times_Sold
FROM orders
GROUP BY Category, Sub_Category
ORDER BY Times_Sold DESC
LIMIT 1;

-- 5)Most Loyal Customer
SELECT Customer_Name, COUNT(DISTINCT Order_ID) AS Total_Orders
FROM orders
GROUP BY Customer_Name
ORDER BY Total_Orders DESC
LIMIT 1;

-- 6)Best Day & Month
SELECT 
    DAYNAME(Order_Date) AS Day_Name,
    MONTHNAME(Order_Date) AS Month_Name,
    COUNT(*) AS Total_Orders
FROM orders
GROUP BY Day_Name, Month_Name
ORDER BY Total_Orders DESC
LIMIT 1;

---- 2))Analysis in terms of Sales and Profit

-- 1) Sales-Profit Ratio Per Customer
SELECT 
    Customer_Name,
    ROUND(SUM(Sales), 0) AS Total_Sales,
    ROUND(SUM(Profit), 0) AS Total_Profit,
    ROUND(SUM(Profit)/NULLIF(SUM(Sales),0)*100, 1) AS Profit_Margin_Pct
FROM orders
GROUP BY Customer_Name
HAVING SUM(Sales) > 0
ORDER BY Total_Profit DESC
LIMIT 10;

-- 2)Most Region, State, City Sales & Profit
SELECT 
    Region, 
    State, 
    City,
    ROUND(SUM(Sales), 0) AS Total_Sales,
    ROUND(SUM(Profit), 0) AS Total_Profit,
    ROUND(SUM(Profit)/NULLIF(SUM(Sales),0)*100, 1) AS Profit_Margin_Pct
FROM orders
GROUP BY Region, State, City
ORDER BY Total_Profit DESC
LIMIT 1;

-- 3)Which Segment is Profitable more
SELECT 
    Segment,
    ROUND(SUM(Sales), 0) AS Total_Sales,
    ROUND(SUM(Profit), 0) AS Total_Profit,
    ROUND(SUM(Profit)/NULLIF(SUM(Sales),0)*100, 1) AS Profit_Margin_Pct,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM orders
GROUP BY Segment
ORDER BY Total_Profit DESC;

-- 4)Which Product We Sell & Profitable more
SELECT 
    Product_Name,
    ROUND(SUM(Sales), 0) AS Total_Sales,
    ROUND(SUM(Profit), 0) AS Total_Profit,
    ROUND(SUM(Profit)/NULLIF(SUM(Sales),0)*100, 1) AS Profit_Margin_Pct,
    COUNT(*) AS Times_Sold
FROM orders
GROUP BY Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;

-- 5)Best Seller & Profitable Category and Sub-Category
SELECT 
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 0) AS Total_Sales,
    ROUND(SUM(Profit), 0) AS Total_Profit,
    ROUND(SUM(Profit)/NULLIF(SUM(Sales),0)*100, 1) AS Profit_Margin_Pct,
    COUNT(*) AS Times_Sold
FROM orders
GROUP BY Category, Sub_Category
ORDER BY Total_Profit DESC
LIMIT 5;

--- Bivariate Analysis
-- 1) Profitable Category By Region
WITH RegionCatProfit AS (
    SELECT 
        Region,
        Category,
        SUM(Profit) AS Total_Profit,
        SUM(Sales) AS Total_Sales,
        ROW_NUMBER() OVER(PARTITION BY Region ORDER BY SUM(Profit) DESC) AS rn
    FROM orders
    GROUP BY Region, Category
)
SELECT 
    Region,
    Category,
    ROUND(Total_Sales, 0) AS Total_Sales,
    ROUND(Total_Profit, 0) AS Total_Profit,
    ROUND(Total_Profit/NULLIF(Total_Sales,0)*100, 1) AS Profit_Margin_Pct
FROM RegionCatProfit
WHERE rn = 1
ORDER BY Total_Profit DESC;

-- 2) Bestseller Day By Category
WITH DayCatSales AS (
    SELECT 
        Category,
        DAYNAME(Order_Date) AS Day_Of_Week,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        ROW_NUMBER() OVER(PARTITION BY Category ORDER BY SUM(Sales) DESC) AS rn
    FROM orders
    GROUP BY Category, DAYNAME(Order_Date)
)
SELECT 
    Category,
    Day_Of_Week,
    ROUND(Total_Sales, 0) AS Total_Sales,
    ROUND(Total_Profit, 0) AS Total_Profit
FROM DayCatSales
WHERE rn = 1
ORDER BY Total_Sales DESC;

-- 3) Profitable Ship Mode By Region
WITH RegionShipProfit AS (
    SELECT 
        Region,
        Ship_Mode,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        ROW_NUMBER() OVER(PARTITION BY Region ORDER BY SUM(Profit) DESC) AS rn
    FROM orders
    GROUP BY Region, Ship_Mode
)
SELECT 
    Region,
    Ship_Mode,
    ROUND(Total_Sales, 0) AS Total_Sales,
    ROUND(Total_Profit, 0) AS Total_Profit,
    ROUND(Total_Profit/NULLIF(Total_Sales,0)*100, 1) AS Profit_Margin_Pct
FROM RegionShipProfit
WHERE rn = 1
ORDER BY Total_Profit DESC;

-- 4) Best Seller Month By Category
WITH MonthCatSales AS (
    SELECT 
        Category,
        MONTHNAME(Order_Date) AS Month,
        MONTH(Order_Date) AS Month_Num,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        ROW_NUMBER() OVER(PARTITION BY Category ORDER BY SUM(Sales) DESC) AS rn
    FROM orders
    GROUP BY Category, MONTHNAME(Order_Date), MONTH(Order_Date)
)
SELECT 
    Category,
    Month,
    ROUND(Total_Sales, 0) AS Total_Sales,
    ROUND(Total_Profit, 0) AS Total_Profit
FROM MonthCatSales
WHERE rn = 1
ORDER BY Month_Num;

-- 5) Best Seller Sub-Category By Segment
WITH SegmentSubCatSales AS (
    SELECT 
        Segment,
        Sub_Category,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        ROW_NUMBER() OVER(PARTITION BY Segment ORDER BY SUM(Sales) DESC) AS rn
    FROM orders
    GROUP BY Segment, Sub_Category
)
SELECT 
    Segment,
    Sub_Category,
    ROUND(Total_Sales, 0) AS Total_Sales,
    ROUND(Total_Profit, 0) AS Total_Profit,
    ROUND(Total_Profit/NULLIF(Total_Sales,0)*100, 1) AS Profit_Margin_Pct
FROM SegmentSubCatSales
WHERE rn = 1
ORDER BY Total_Sales DESC;

-- 4)MultiVariate Analysis
-- 1) Sales vs Profit Correlation Check
SELECT 
    ROUND(
        (COUNT(*) * SUM(Sales * Profit) - SUM(Sales) * SUM(Profit)) / 
        SQRT((COUNT(*) * SUM(Sales * Sales) - SUM(Sales) * SUM(Sales)) * 
             (COUNT(*) * SUM(Profit * Profit) - SUM(Profit) * SUM(Profit)))
    , 3) AS Sales_Profit_Correlation
FROM orders;

-- 2) Discount vs Profit Correlation
SELECT 
    ROUND(
        (COUNT(*) * SUM(Discount * Profit) - SUM(Discount) * SUM(Profit)) / 
        SQRT((COUNT(*) * SUM(Discount * Discount) - SUM(Discount) * SUM(Discount)) * 
             (COUNT(*) * SUM(Profit * Profit) - SUM(Profit) * SUM(Profit)))
    , 3) AS Discount_Profit_Correlation
FROM orders
WHERE Discount > 0; -- Only discounted orders

-- 3) Quantity vs Profit Correlation
SELECT 
    ROUND(
        (COUNT(*) * SUM(Quantity * Profit) - SUM(Quantity) * SUM(Profit)) / 
        SQRT((COUNT(*) * SUM(Quantity * Quantity) - SUM(Quantity) * SUM(Quantity)) * 
             (COUNT(*) * SUM(Profit * Profit) - SUM(Profit) * SUM(Profit)))
    , 3) AS Quantity_Profit_Correlation
FROM orders;
