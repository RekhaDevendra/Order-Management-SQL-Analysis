--1) Objective: Combining data from multiple tables to understand the relationships between orders, products, materials, and suppliers.
-- Goals: Retrieve detailed information about orders and their associated products and materials.

-- Inner Join to retrieve detailed order information with product details

SELECT O.ORDER_ID,
	O.CUSTOMER_NAME,
	P.PRODUCT_NAME,
	M.MATERIAL_NAME,
	S.SUPPLIER_NAME
FROM ORDERS O
INNER JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
INNER JOIN MATERIALS M ON P.MATERIAL_ID = M.MATERIAL_ID
INNER JOIN SUPPLIERS S ON P.PRODUCT_ID = S.PRODUCT_ID;

--2)Objective: Aggregate data to get insights into the most popular products and materials.
--Goals: Find out which products and materials have the highest demand and how many orders they are associated with.

SELECT M.MATERIAL_NAME,
	COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM ORDERS O
INNER JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
INNER JOIN MATERIALS M ON P.MATERIAL_ID = M.MATERIAL_ID
GROUP BY M.MATERIAL_NAME;

-- 3) Objective: Categorize product orders into three price categories ('Low,' 'Medium,' and 'High') based on their prices and limit the results.
-- Goals:1)Categorize product orders by their price into three distinct categories to gain insights into pricing distribution.
-- 		 2)Display a limited set of the categorized product orders for quick assessment and review.

 -- --CTE, CASE Statement and Where Condition
 WITH CATEGORIZEDORDERS AS
	(SELECT O.ORDER_ID,
			O.CUSTOMER_NAME,
			O.ORDER_DATE,
			P.PRODUCT_NAME,
			P.PRODUCT_PRICE,
			CASE
				WHEN P.PRODUCT_PRICE < 100 THEN 'Low'
				WHEN P.PRODUCT_PRICE >= 100
				AND P.PRODUCT_PRICE <= 300 THEN 'Medium'
 				ELSE 'High'
 			END AS PRICE_CATEGORY
	FROM ORDERS O
	LEFT JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID)
SELECT ORDER_ID,
	CUSTOMER_NAME,
	ORDER_DATE,
	PRODUCT_NAME,
	PRODUCT_PRICE,
	PRICE_CATEGORY
FROM CATEGORIZEDORDERS
WHERE PRICE_CATEGORY = 'High'; ---- Filter for 'High' price category

--4)Objective: Analyze the manufacturing data to identify the top customers with the highest order values.
-- Goals: 1) Group orders by customer name.
--		  2) Calculate the total order value for each customer.
--		  3) Identify the top customers based on their total order values.
--		  4) Limit the result set to a specific number of top customers.

SELECT CUSTOMER_NAME,
	SUM(PRODUCT_PRICE) AS TOTAL_ORDER_VALUE
FROM ORDERS O
INNER JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
GROUP BY CUSTOMER_NAME
ORDER BY TOTAL_ORDER_VALUE DESC
LIMIT 10; -- Limit the result to the top 10 customers with the highest order values

--5)Objective: Analyze product pricing within specific price ranges and identify products with unique price points.
-- Goals: 1) Calculate and display the minimum and maximum product prices.
--		  2) Identify products with unique price points within specific price ranges.

-- Find the minimum and maximum product prices

SELECT MIN(PRODUCT_PRICE) AS MIN_PRICE,
	MAX(PRODUCT_PRICE) AS MAX_PRICE
FROM PRODUCTS;

-- Find products with unique price points within specific price ranges

SELECT PRODUCT_NAME,
	PRODUCT_PRICE
FROM PRODUCTS
GROUP BY PRODUCT_NAME,
	PRODUCT_PRICE
HAVING COUNT(PRODUCT_PRICE) = 1
AND PRODUCT_PRICE BETWEEN 100 AND 200;

--6) Objective: The main objective is to provide additional insights into the pricing structure of products in the dataset.
-- Goals:1) Calculate the total price of all products in the dataset.
--		2) Calculate the average price of products.
--		3) Determine the price difference between the product with the highest price and the one with the lowest price.
 
 WITH PRICESUMMARY AS
	(SELECT SUM(PRODUCT_PRICE) AS TOTAL_PRICE,
			AVG(PRODUCT_PRICE) AS AVERAGE_PRICE,
			MAX(PRODUCT_PRICE) - MIN(PRODUCT_PRICE) AS PRICE_DIFFERENCE
		FROM PRODUCTS)
SELECT TOTAL_PRICE,
	AVERAGE_PRICE,
	PRICE_DIFFERENCE
FROM PRICESUMMARY;

--7) Objective: Create a view to consolidate product order details from the provided manufacturing tables, 
--    with the goal of providing a unified and easily accessible view of product orders.
--Goals: 1)Consolidate product order details from multiple tables into a single view.
--       2)Provide a clear and unified view of product order data for analysis and reporting.
--       3)Simplify access to product order information for various stakeholders in the manufacturing process.

-- Create a view to consolidate product order details
CREATE VIEW PRODUCT_ORDER_DETAILS AS
SELECT O.ORDER_ID,
	O.CUSTOMER_NAME,
	O.ORDER_DATE,
	O.ORDER_STATUS,
	P.PRODUCT_ID,
	P.PRODUCT_NAME,
	P.PRODUCT_PRICE,
	P.PRODUCT_DESCRIPTION,
	M.MATERIAL_ID,
	M.MATERIAL_NAME,
	M.MATERIAL_PRICE,
	M.MATERIAL_DESCRIPTION
FROM ORDERS O
JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
JOIN MATERIALS M ON P.MATERIAL_ID = M.MATERIAL_ID;

--8)Objective: Creating a funnel-like structure view for the manufacturing tables can be a useful way to visualize and analyze data.
-- Goals: The idea is to segment the data in a step-by-step manner, just like a funnel narrows down as we progress through different stages.
--  In the context of manufacturing, this could be used to track the progress of products or orders through various stages of production, 
--such as material selection, production, quality control, and shipping.

-- Created a view to represent the manufacturing funnel

CREATE OR REPLACE VIEW MANUFACTURING_FUNNEL AS WITH ORDERPROGRESSION AS
	(SELECT O.ORDER_ID,
			O.CUSTOMER_NAME,
			'Order Received' AS STAGE
		FROM ORDERS O
		UNION ALL SELECT O.ORDER_ID,
			O.CUSTOMER_NAME,
			'Material Selected' AS STAGE
		FROM ORDERS O
		WHERE EXISTS
				(SELECT 1
					FROM MATERIALS M
					WHERE M.MATERIAL_ID =
							(SELECT MATERIAL_ID
								FROM PRODUCTS P
								WHERE P.PRODUCT_ID = O.PRODUCT_ID) )
		UNION ALL SELECT O.ORDER_ID,
			O.CUSTOMER_NAME,
			'Product Manufactured' AS STAGE
		FROM ORDERS O
		WHERE EXISTS
				(SELECT 1
					FROM PRODUCTS P
					WHERE P.PRODUCT_ID = O.PRODUCT_ID )
		UNION ALL SELECT O.ORDER_ID,
			O.CUSTOMER_NAME,
			'Quality Control Passed' AS STAGE
		FROM ORDERS O
		WHERE O.ORDER_STATUS = 'Quality Checked'
		UNION ALL SELECT O.ORDER_ID,
			O.CUSTOMER_NAME,
			'Shipped' AS STAGE
		FROM ORDERS O
		WHERE O.ORDER_STATUS = 'Shipped' )
SELECT STAGE,
	COUNT(DISTINCT ORDER_ID) AS ORDERS_IN_STAGE
FROM ORDERPROGRESSION
GROUP BY STAGE
ORDER BY MIN(ORDER_ID);

/*9) Objective: Create a view that combines order and supplier details from the provided tables, enhancing the ability to 
access and analyze data for manufacturing operations.
Goals:1) Consolidate order and supplier details into a single view, simplifying data access.
2) Facilitate data analysis and decision-making by providing an integrated view of orders and their corresponding suppliers.
*/

CREATE OR REPLACE VIEW ORDER_SUPPLIER_DETAILS AS
SELECT O.ORDER_ID,
	O.CUSTOMER_NAME AS ORDER_CUSTOMER_NAME,
	O.ORDER_DATE,
	O.ORDER_STATUS,
	P.PRODUCT_ID,
	P.PRODUCT_NAME,
	P.PRODUCT_PRICE,
	P.PRODUCT_DESCRIPTION,
	S.SUPPLIER_ID,
	S.SUPPLIER_NAME AS SUPPLIER_NAME,
	S.PHONE_NUMBER AS SUPPLIER_PHONE_NUMBER,
	S.SUPPLIER_ADDRESS
FROM ORDERS O
JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID
JOIN SUPPLIERS S ON P.PRODUCT_ID = S.PRODUCT_ID;

/*10) Objective: To categorize the product orders based on specific keywords or patterns within their product names and descriptions, 
with the goal of identifying and analyzing orders that match predefined criteria.
Goals: 1)Categorize product orders into specific groups based on the presence of keywords or patterns in their product names and descriptions.
2)Facilitate analysis and decision-making by providing a structured view of orders that match the specified criteria.
Categorize product orders based on keywords or patterns in product names and descriptions
 */
 
 WITH CATEGORIZEDORDERS AS
	(SELECT O.ORDER_ID,
			O.CUSTOMER_NAME,
			O.ORDER_DATE,
			P.PRODUCT_NAME,
			P.PRODUCT_PRICE,
			P.PRODUCT_DESCRIPTION,
			CASE
				 WHEN (P.PRODUCT_NAME ILIKE '%steel%'
									  OR P.PRODUCT_DESCRIPTION ILIKE '%steel%') THEN 'Steel Products'
				 WHEN (P.PRODUCT_NAME ILIKE '%plastic%'
									  OR P.PRODUCT_DESCRIPTION ILIKE '%plastic%') THEN 'Plastic Products'
				 WHEN (P.PRODUCT_NAME ILIKE '%copper%'
									  OR P.PRODUCT_DESCRIPTION ILIKE '%copper%') THEN 'Copper Products'
				 ELSE 'Other Products'
			END AS CATEGORY
	FROM ORDERS O
	LEFT JOIN PRODUCTS P ON O.PRODUCT_ID = P.PRODUCT_ID)
SELECT ORDER_ID,
	CUSTOMER_NAME,
	ORDER_DATE,
	PRODUCT_NAME,
	PRODUCT_PRICE,
	PRODUCT_DESCRIPTION,
	CATEGORY
FROM CATEGORIZEDORDERS;


--11) Objectives: Extracting and formatting data in a useful way, such as formatting phone numbers for readability
-- Goal: Extract phone numbers with a specific format

SELECT SUPPLIER_ID,
	SUPPLIER_NAME,
	REGEXP_REPLACE(PHONE_NUMBER::text,

		'(\d{3})(\d{3})(\d{4})',
		'(\1) \2-\3') AS FORMATTED_PHONE
FROM SUPPLIERS;



