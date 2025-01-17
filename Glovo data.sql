-- A. Executive Summary:

--1. What is the total number of orders placed on the platform?
SELECT COUNT([order_id]) AS Num_of_orders
FROM [dbo].[Orders (1)]

--2. Identify the minimum, maximum and average delivery time across all orders.
SELECT Min([delivery_duration]) AS Min_delivery_time, MAX([delivery_duration]) AS Max_delivery_time,
AVG([delivery_duration]) AS Avg_delivery_time
FROM [dbo].[Deliveries]

--B. Customer Insights:

--3. What is the total amount spent by customers on orders?
SELECT SUM([total_amount]) AS Total_amount_spent
FROM [dbo].[Orders (1)]

--4. Who are the top 5 customers based on their total order value?
SELECT TOP 5 c.[full_name], SUM(o.[total_amount]) AS Total_order_value
FROM [dbo].[Customers - Customers] AS c
INNER JOIN [dbo].[Orders (1)] as o
ON c.[customer_id]=o.[customer_id]
GROUP BY [full_name]
ORDER BY Total_order_value DESC

--5. Which customer(s) have spent more than the average total amount across all orders?
SELECT o.[customer_id], c.[full_name],  SUM(o.[total_amount]) AS Total_amount
FROM [dbo].[Customers - Customers] AS c
INNER JOIN [dbo].[Orders (1)] AS o
ON c.[customer_id] = o.[customer_id]
GROUP BY o.[customer_id],[full_name]
HAVING SUM(o.[total_amount]) > 
(SELECT AVG([total_amount]) FROM [dbo].[Orders (1)])
ORDER BY Total_amount DESC
  
--C. Restaurant Performance:

--6. What is the total number of orders placed for each restaurant?
SELECT r.[name], COUNT(o.[order_id]) AS Num_of_orders
FROM [dbo].[Restaurants] AS r
INNER JOIN [dbo].[Orders (1)] AS o
ON r.[restaurant_id] =o.[restaurant_id]
GROUP BY [name]
ORDER BY Num_of_orders DESC

--7. Which restaurant has the highest average rating from customers?
SELECT TOP 1 [name],[average_rating]
FROM [dbo].[Restaurants]
ORDER BY [average_rating] DESC

-- D. Delivery Efficiency:

--8. What is the average delivery time by each delivery zone?
SELECT ri.[assigned_location], AVG(d.[delivery_duration]) AS Avg_delivery_time
FROM [dbo].[Riders] AS ri
INNER JOIN [dbo].[Deliveries] AS d
ON ri.[rider_id] = d.[rider_id]
GROUP BY [assigned_location]

--9. Identify delivery zones where the average delivery time exceeds the 30 minutes SLA benchmark.
SELECT ri.[assigned_location], AVG(d.[delivery_duration]) AS 'Avg delivery time>30'
FROM [dbo].[Riders] AS ri
INNER JOIN [dbo].[Deliveries] AS d
ON ri.[rider_id] = d.[rider_id]
GROUP BY [assigned_location]
HAVING AVG(d.[delivery_duration]) > 30

--10. Which rider completed the fastest delivery, and what was the time?
SELECT TOP 1 ri.[rider_id], ri.[full_name],MIN([delivery_duration]) AS Fastest_delivery_time
FROM [dbo].[Riders] AS ri
INNER JOIN [dbo].[Deliveries] AS d
ON ri.[rider_id] = d.[rider_id]
WHERE [delivery_duration] = (SELECT MIN([delivery_duration]) FROM [dbo].[Deliveries])
GROUP BY ri.[rider_id], [full_name]
ORDER BY Fastest_delivery_time ASC
  
--E. Order Trends:

--11. What are the top 3 most ordered foods?
SELECT TOP 3 f.[name], COUNT(o.[order_id]) AS Num_of_orders
FROM [dbo].[Foods] AS f
INNER JOIN [dbo].[Orders (1)] AS o
ON f.[food_id] = o.[food_id]
GROUP BY [name]
ORDER BY Num_of_orders DESC

--12. Which customer placed the most orders, and which restaurant did they order from the most.
SELECT TOP 1 c.[customer_id], c.[full_name], r.[name], count(o.[order_id]) Num_of_orders
FROM [dbo].[Customers - Customers] AS c
INNER JOIN [dbo].[Orders (1)] AS o
ON c.[customer_id] = o.[customer_id]
INNER JOIN Restaurants AS r
ON o.[restaurant_id] = r.[restaurant_id]
WHERE o.[customer_id] =  (SELECT TOP 1 o.[customer_id]
FROM  [dbo].[Orders (1)]AS o
GROUP BY o.[customer_id]
ORDER BY COUNT(o.[order_id]) DESC)
GROUP BY c.[customer_id], c.[full_name], r.[name]
ORDER BY Num_of_orders DESC

--13. Generate a report of all canceled orders for QA to log.
SELECT *
FROM [dbo].[Orders (1)]
WHERE [status] = 'Cancelled'

--14. How many customers have placed more than 10 orders
SELECT COUNT(*) AS 'Num of customers'
FROM (SELECT o.customer_id, COUNT(*) AS o
FROM [dbo].[Orders (1)]as o
GROUP BY customer_id 
HAVING COUNT(*) > 10) AS o

--15. Provide a list of all orders where the order value exceeds the average order value across the platform.
SELECT [order_id], [total_amount]
FROM [dbo].[Orders (1)]
WHERE [total_amount] >
(SELECT AVG([total_amount]) FROM [dbo].[Orders (1)])
ORDER BY [total_amount] DESC

--F. More Operational Insights:

--16. Generate a report of all riders who delivered more than 100 orders. Include in 
--the report, their respective total number of orders delivered.
SELECT ri.[rider_id], ri.[full_name], COUNT(d.[order_id]) AS Num_of_deliveries
FROM [dbo].[Riders] AS ri
INNER JOIN [dbo].[Deliveries] AS d
ON ri.[rider_id] = d.[rider_id]
GROUP BY ri.[rider_id], [full_name] 
HAVING COUNT(d.[order_id]) > 100

--17. How many partner restaurants do we currently have on the Island and how many on the Mainland?
SELECT COUNT([restaurant_id]) AS Restaurants_on_island
FROM [dbo].[Restaurants]
WHERE [location] IN ('Victoria Island', 'Lekki') 
(SELECT COUNT([restaurant_id]) AS Restaurants_on_mainland FROM [dbo].[Restaurants] 
WHERE [location] IN ('Surulere', 'Yaba', 'Ikeja'))







