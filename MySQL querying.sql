# Task 1.A Describe the data in your own words

-- The data is divided into 5 csv files:
-- market_fact: This is the main fact table. It contains all the sales related information such as sales, discount, order quantity etc (fact variables stored as double/intergers) for each customer, order, product and shipment (dimension variables stored as text/varchar). IDs are used for all the dimnesional variables and hence they do not offer much insight into the data
-- Cust_dimen: This is a dimension table which gives us metadata regarding the customers such as their name, location (region and province) and customer segment (such as home office, corporate etc). Its linked to the market_fact table via cust_id. Data has been stored in text/varchar format
-- Orders_dimen: This dimension table gives us metadata on the orders placed. It contains the date the order was placed on and the order priority (Critical, low etc). Its linked to the market_fact table via ord_id. 
-- prod_dimen: This dimension table reveals what the product id's mean. Product information is categorised into product category and sub category. Its linked to the market_fact table via prod_id. Data has been stored in text/varchar format
-- shipping_dimen: This dimension table has shipping related information such as shipment date and mode of shipment (truck, air etc). Shipments are linked to orders, it can be seen that one order can have multiple shipments. It's linked to the market_fact table via Ship_id. Data has been stored in text/varchar format

# Task 1.B Identify and list the primary and foreign keys for the dataset

-- market_fact: This tables has no primary keys (combination of cust_id, prod_id, ord_id and ship_id is also not unique) Ord_id is a foreign key to order_dimen table; cust_id is a foreign key to cust_dimen; prod_id is a foreign key to prod_dimen; ship_id is a foregn key for shipping_dimen.
-- cust_dimen: cust_id is the primary key of this table, there are no foreign keys in this table
-- order_dimen: Ord_id is the primary key for this table. there are no foreign keys in this table
-- prod_dimen: prod_id acts as primary key for this table and there are no foreign keys in this table
-- shipping_dimen: ship_id acts as primary key for this table. There are no foreign keys in this table

# Task 2.A Find the total and average sales (display total_sales and avg_sales)

select sum(Sales) as total_sales, avg(sales) as avg_sales	 				-- renaming sum(sales) as total_sales and avg(sales) as avg_sales
from market_fact;

# Task 2.B Display the number of customers in each region in decreasing order of no_of_customers. The result should contain columns Region, no_of_customers

select region, count(cust_id) as no_of_customers 							-- renaming count(cust_id) as no_of_customers
from cust_dimen
group by region
order by no_of_customers desc; 												-- in descending order of no_of_customers

# Task 2.C Find the region having maximum customers (display the region name and max(no_of_customers)

select region, count(cust_id) as no_of_customers
from cust_dimen
group by Region
order by count(Cust_id) desc
limit 1;																	-- Limit arguement to show only top row i.e. max(no_of_customers)

# Task 2.D Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)

select prod_id, sum(Order_Quantity) as no_of_products_sold 					-- renaming sum(order_quantity) as no_of _products_Sold
from market_fact
group by Prod_id
order by no_of_products_sold desc; 											-- sorting in decreasing order of products sold

# Task 2.E Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)

select customer_name, sum(order_quantity) as no_of_tables_purchased 		-- renaming sum(order_quantity) as no_of_tables_purchased. Sum is used as one customer may have purchased tables more than once
from market_fact m															-- calling market_fact table as m
left outer join cust_dimen c on m.Cust_id = c.Cust_id 						-- left outer join to ensure all data from market_fact table is retreived
left outer join prod_dimen p on p.prod_id = m.prod_id 						
where c.Region = "Atlantic" and p.Product_Sub_Category = "Tables"			-- applying filter on region and product sub category
group by m.Cust_id 															-- customer name is non-unique
order by no_of_tables_purchased desc; 										-- optional sort to neatly present the results
		
# Task 3.A Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?

select product_category, sum(profit) as profits 							-- Sum(profits) is used as each product cateogry is part of multiple orders
from market_fact m
left outer join prod_dimen p on p.Prod_id = m.Prod_id     					-- joining prod_dimen table to retreive prod_id's per product category
group by Product_Category
order by profits desc;

# Task 3.B Display the product category, product sub-category and the profit within each subcategory in three columns.

select product_category, Product_Sub_Category, sum(profit) as profits 		-- Sum(profits) is used as each product sub category is part of multiple orders
from market_fact m
left outer join prod_dimen p on p.Prod_id = m.Prod_id     					-- joining prod_dimen table to retreive prod_id's per product category and sub category
group by Product_Category, Product_Sub_Category 							-- grouping on two levels: product category and product sub category. Results are shown at second level
order by Product_Category, Product_Sub_Category; 							-- optional sort alphabetically to neatly present the results

# Task 3.C Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)

-- Query to identify product sub category with least profits, this can be also be identified as being "Tables" by visual inspeaction from Task 3.B
select product_sub_category 												
from market_fact m
left outer join prod_dimen p on p.Prod_id = m.Prod_id 						-- joining prod_dimen to retreive product sub categories
group by Product_Sub_Category
order by sum(profit) 														-- order cluase from lowest profits to highest profits
limit 1; 																	-- limit clause to retreive only the lowest

-- Query to find where the least profitable product sub category (Tables) is shipped to the most
select region, count(Ship_id)
from market_fact m
left outer join cust_dimen c on  c.Cust_id = m.Cust_id
left outer join prod_dimen p on p.Prod_id = m.Prod_id
where Product_Sub_Category = "Tables" 										-- least profitable product sub category identified as Tables from previoud query
group by region
order by count(Ship_id) desc
limit 1;

-- Query to list region wise no_of_shipements and profits for the least profitable product sub category (Tables)
select region, count(Ship_id) as no_of_shipments, sum(Profit) as profit_in_each_region
from market_fact m
left outer join cust_dimen c on c.Cust_id = m.Cust_id 						-- joining cust_dimen to retreive customer regions
left outer join prod_dimen p on p.Prod_id = m.Prod_id 						-- joining prod_dimen to retreive product sub categories
where p.Product_Sub_Category = "Tables" 									-- hardcoded the name of the least profitable sub category 
group by region 															-- displaying results by region
order by profit_in_each_region desc;										-- displaying results in decreasing order of profits


