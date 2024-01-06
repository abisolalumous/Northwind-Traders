-- Analyzing the Products table
SELECT *
FROM Project.dbo.products

-- List of Products
SELECT productID,productNAME
 FROM Project.dbo.products

 -- Number of products
 SELECT COUNT(productName)
FROM Project.dbo.products
WHERE discontinued=0
-- 69 products are being stocked
-- Discontinued products

SELECT productID,productName
FROM Project.dbo.products
WHERE discontinued=1


--Number of discontinued product
 SELECT COUNT(productName)
FROM Project.dbo.products
WHERE discontinued=1
-- 8 Products was discontinued

--Product by categories
SELECT p.productID,p.productName,c.categoryName
FROM Project.dbo.products AS p
JOIN Project.dbo.categories AS c
ON p.categoryID=c.categoryID
GROUP BY c.categoryName,p.productID,p.productName

SELECT*
FROM Project.dbo.order_details

-- Total Orders
SELECT COUNT(orderID) AS TotalOrders
FROM Project.dbo.orders

--Total Orders 830


-- Total Sales Revenue
SELECT SUM(unitPrice*quantity)AS TotalRevenue
FROM Project.dbo.order_details

-- Total Sales Revenue 1,354,458.99

--  Sales Revenue per orderID
SELECT orderID,SUM(unitPrice*quantity)AS TotalRevenue
FROM Project.dbo.order_details
GROUP BY orderID

-- Top Selling Products
SELECT TOP 10 od.productID,p.productName,Sum(od.quantity)AS TotalQuantitySold
FROM Project.dbo.order_details  AS od
JOIN Project.dbo.products AS p ON
od.productID=p.productID
GROUP BY od.productID,p.productName
ORDER BY TotalQuantitySold DESC

-- Least Selling Products
SELECT TOP 10 od.productID,p.productName,Sum(od.quantity)AS TotalQuantitySold
FROM Project.dbo.order_details  AS od
JOIN Project.dbo.products AS p ON
od.productID=p.productID
GROUP BY od.productID,p.productName
ORDER BY TotalQuantitySold 

/*productID	productName	TotalQuantitySold
9	Mishi Kobe Niku	95
15	Genen Shouyu	122
37	Gravad lax	125
48	Chocolade	138
67	Laughing Lumberjack Lager	184
50	Valkoinen suklaa	235
66	Louisiana Hot Spiced Okra	239
73	Röd Kaviar	293
74	Longlife Tofu	297
32	Mascarpone Fabioli	2978*/

-- How many products are in each order,How many products and total amout paid
SELECT DISTINCT orderID,
	COUNT(orderID) OVER (PARTITION BY orderID) Unique_product,
	SUM(quantity) OVER (PARTITION BY orderID) Total_Quantity,
	SUM(unitPrice * quantity) OVER (PARTITION BY orderID)TotalQuantitySold
	FROM Project.dbo.order_details
	

--Sales by Country
SELECT c.country,o.customerID,
		SUM(od.unitPrice*od.quantity)AS CountrySales
FROM Project.dbo.customers AS c
JOIN 
Project.dbo.orders AS o ON c.customerID=o.customerID
JOIN Project.dbo.order_details AS od ON od.orderID=o.orderID
GROUP BY c.country,o.customerID
ORDER BY CountrySales DESC

-- Germany is the Top country by sales with a volume of 117,483,39

-- Monthly Sales trends

SELECT FORMAT(o.orderDate,'yyyy-MM')AS Month,
		SUM(od.unitPrice*od.quantity)AS MonthlySales
		FROM Project.dbo.orders AS o
		JOIN Project.dbo.order_details AS od
		ON o.orderID=od.orderID
		GROUP BY FORMAT(o.orderDate,'yyyy-MM')
		ORDER BY Month
		
		-- List OF Customers
		SELECT companyName,country
		FROM	Project.dbo.customers


		-- Number of customers
		SELECT COUNT(DISTINCT customerID)
		FROM	Project.dbo.customers
		-- Northwind Traders has 91 customers

		-- Number of Order Per Customers
		SELECT TOP 3 o.customerID,c.companyName,
				COUNT(DISTINCT o.orderID) AS numOrders,
				SUM(od.unitPrice*od.quantity)AS TotalSales
				FROM Project.dbo.orders AS o
				JOIN Project.dbo.customers AS c
				ON c.customerID=O.customerID
				JOIN Project.dbo.order_details AS od
				ON o.orderID=od.orderID
				GROUP BY c.companyName,o.customerID 
				ORDER BY numOrders DESC
-- The  key customers are Save-a-lot Markets Wth 31 Orders and Total sales od 115,673.39
							-- Ernst Handel with 30 orders and sales of 113,236.68	
							-- QUICK-Stop with 28 orders and sales of	117,483.39

--List of Shippers
SELECT shipperID,companyName
FROM Project.dbo.shippers
							
-- number of shippers
SELECT COUNT(shipperID)
FROM Project.dbo.shippers
-- 3shipping companies

SELECT  s.shipperID,s.companyName,COUNT(orderID)AS NumOrders
FROM Project.dbo.orders AS o
JOIN Project.dbo.shippers AS s
ON o.shipperID=s.shipperID
GROUP BY s.shipperID,s.companyName
ORDER BY NumOrders DESC

/*shipperID  panyName	NumOrders
2	United Package	326
3	Federal Shipping	255
1	Speedy Express	249
GROUP BY ShipperID

-- Orders shipped late

SELECT
o.orderID,
 o.orderDate,
  o.requiredDate,
 o.shippedDate,
    CASE WHEN
shippedDate>requiredDate THEN'Late'
ELSE 'Ontime'
    END AS ShipmentStatus,s.companyName
FROM
    Project.dbo.orders AS o
	JOIN Project.dbo.shippers AS s
	ON s.shipperID=o.shipperID
WHERE
   shippedDate >requiredDate;


   SELECT COUNT(orderID)AS Lateorderdatecount,s.companyName
      FROM
    Project.dbo.orders AS o
	JOIN Project.dbo.shippers AS s
	ON s.shipperID=o.shipperID
   WHERE shippedDate> requiredDate
   GROUP BY s.companyName

   -- 37 late orders

	SELECT
    AVG(DATEDIFF(ShippedDate, RequiredDate)) AS AvgShippingDelay
FROM
    Orders
WHERE
    ShippedDate IS NOT NULL AND RequiredDate IS NOT NULL;
ORDER BY NumberOfOrders DESC;
FROM Project.dbo.shippers*/