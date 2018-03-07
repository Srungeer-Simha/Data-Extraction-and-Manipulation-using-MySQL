# Data-Extraction-and-Manipulation-using-MySQL

This code contains queries such as selecting data, joining tables, sorting, filtering etc, that are typically used for extracting information from relational databases.

Sample retail store data (divided into 5 csv files) for the code is in the accompanying zip file. A schema needs to be created and data has to be loaded manaually into MySQL Wokrbench for this exercise.

File names and description:
1. cust_dimen - Information about the customers of the store
2. orders_dimen - Details of all the orders
3. prod_dimen - contains all the details about all the products available in the store
4. shipping_dimen - contains shipping details
5. market_fact - the biggest file containing the market facts for all products, customers and orders

Steps to import data into MySQL Workbench:
1. Create a database/schema and name it as "superstoresdb"
2. Using the "Navigator" pane at the left-hand side, locate your database i.e. "superstoresdb"
3. Expand it to get the tables list
4. Right-click on the table name to get the menu
5. Select "Table Data Import Wizard" from this menu
6. Follow the steps of the wizard and the data will be imported in respective tables
7. Repeat this process for all the tables
