# Import the necessary modues
import os
import pyodbc
import pandas as pd
import xlrd

# Set the working directory to the location of scripts
os.chdir("C:/Users/guloy/Desktop/BI MID/BI GROUP_WORK/Proj-2/BI_Project-2")

# os.chdir("C:/Users/Desktop/")
# Import the config module 
import readconfig
 
# Call to read the configuration file
c_ER = readconfig.get_sql_config(r'SQL_Server_Config.cfg',"Database1")
c_DW = readconfig.get_sql_config(r'SQL_Server_Config.cfg',"Database2")

# Create a connection string for SQL Server
conn_info_ER = 'Driver={};Server={};Database={};Trusted_Connection={};'.format(*c_ER)
conn_info_DW = 'Driver={};Server={};Database={};Trusted_Connection={};'.format(*c_DW)

# Connect to the server and to the desired database
conn_ER = pyodbc.connect(conn_info_ER)
conn_DW = pyodbc.connect(conn_info_DW)

# Create a Cursor class instance for executing T-SQL statements
cursor_ER = conn_ER.cursor()
cursor_DW = conn_DW.cursor()

#Populate a table in sql server from souce table 

#Region
def populate_table_Region(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([RegionID],[RegionDescription])
			values (?, ?)'''.format(table_name), row['RegionID'], row['RegionDescription']) 
		cursor.commit()

# df_Region = pd.read_excel("data_source.xlsx", sheet_name = 'Region', header = 0)
# df_Region = df_Region.where(pd.notnull(df_Region), None)
# populate_table_Region(cursor_ER, 'Region', df_Region)


#Categories
def populate_table_Categories(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([CategoryID],[CategoryName],[Description])
			values (?, ?, ?)'''.format(table_name), row['CategoryID'], row['CategoryName'], row['Description']) 
		cursor.commit()

# df_Categories = pd.read_excel("data_source.xlsx", sheet_name = 'Categories', header = 0)
# df_Categories = df_Categories.where(pd.notnull(df_Categories), None)
# populate_table_Categories(cursor_ER, 'Categories', df_Categories)

#Suppliers
def populate_table_Suppliers(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([SupplierID],[CompanyName],[ContactName],[ContactTitle],[Address],[City],[Region],[PostalCode],[Country],[Phone],[Fax],[HomePage])
			values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'''.format(table_name),row['SupplierID'],row['CompanyName'],row['ContactName'],row['ContactTitle'],row['Address'],row['City'],row['Region'],row['PostalCode'],row['Country'],row['Phone'],row['Fax'],row['HomePage']) 
		cursor.commit()

# df_Suppliers = pd.read_excel("data_source.xlsx", sheet_name ='Suppliers', header = 0)
# df_Suppliers = df_Suppliers.where(pd.notnull(df_Suppliers), None)
# populate_table_Suppliers(cursor_ER, 'Suppliers', df_Suppliers)

#Customers 
def populate_table_Customers(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([CustomerID],[CompanyName],[ContactName],[ContactTitle],[Address],[City],[Region],[PostalCode],[Country],[Phone],[Fax])
			values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'''.format(table_name),row['CustomerID'],row['CompanyName'],row['ContactName'],row['ContactTitle'],row['Address'],row['City'],row['Region'],row['PostalCode'],row['Country'],row['Phone'],row['Fax']) 
		cursor.commit()

# df_Customers = pd.read_excel("data_source.xlsx", sheet_name ='Customers', header = 0)
# df_Customers = df_Customers.where(pd.notnull(df_Customers), None)
# populate_table_Customers(cursor_ER, 'Customers', df_Customers)

# Shippers
def populate_table_Shippers(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([ShipperID],[CompanyName],[Phone])
			values (?, ?, ?)'''.format(table_name), row['ShipperID'], row['CompanyName'], row['Phone']) 
		cursor.commit()

# df_Shippers = pd.read_excel("data_source.xlsx", sheet_name = 'Shippers', header = 0)
# df_Shippers = df_Shippers.where(pd.notnull(df_Shippers), None)
# populate_table_Shippers(cursor_ER, 'Shippers', df_Shippers)


# Employees
def populate_table_Employees(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([EmployeeID],[LastName],[FirstName],[Title],[TitleOfCourtesy],[BirthDate],[HireDate],[Address],[City],[Region],[PostalCode],[Country],[HomePhone],[Extension],[Notes],[ReportsTo],[PhotoPath])
			values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?)'''.format(table_name),row['EmployeeID'],row['LastName'],row['FirstName'],row['Title'],row['TitleOfCourtesy'],row['BirthDate'],row['HireDate'],row['Address'],row['City'],row['Region'],row['PostalCode'],row['Country'],row['HomePhone'],row['Extension'],row['Notes'],row['ReportsTo'],row['PhotoPath']) 
		cursor.commit()

# df_Employees = pd.read_excel("data_source.xlsx", sheet_name ='Employees', header = 0)
# df_Employees = df_Employees.where(pd.notnull(df_Employees), None)
# populate_table_Employees(cursor_ER, 'Employees', df_Employees)

# Territories
def populate_table_Territories(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([TerritoryID],[TerritoryDescription],[RegionID])
			values (?, ?, ?)'''.format(table_name), row['TerritoryID'], row['TerritoryDescription'], row['RegionID']) 
		cursor.commit()

# df_Territories = pd.read_excel("data_source.xlsx", sheet_name = 'Territories', header = 0)
# df_Territories = df_Territories.where(pd.notnull(df_Territories), None)
# populate_table_Territories(cursor_ER, 'Territories', df_Territories)


#EmployeeTerritories
def populate_table_EmployeeTerritories(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([EmployeeID],[TerritoryID])
			values (?, ?)'''.format(table_name), row['EmployeeID'], row['TerritoryID']) 
		cursor.commit()

# df_EmployeeTerritories = pd.read_excel("data_source.xlsx", sheet_name = 'EmployeeTerritories', header = 0)
# df_EmployeeTerritories = df_EmployeeTerritories.where(pd.notnull(df_EmployeeTerritories), None)
# df_EmployeeTerritories['EmployeeID'] = df_EmployeeTerritories['EmployeeID'].astype('int')
# df_EmployeeTerritories['TerritoryID'] = df_EmployeeTerritories['TerritoryID'].astype('str')

# populate_table_EmployeeTerritories(cursor_ER, 'EmployeeTerritories', df_EmployeeTerritories)



# Orders
def populate_table_Orders(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([OrderID],[CustomerID],[EmployeeID],[OrderDate],[RequiredDate],[ShippedDate],[ShipVia],[Freight],[ShipName],[ShipAddress],[ShipCity],[ShipRegion],[ShipPostalCode],[ShipCountry])
			values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?)'''.format(table_name),row['OrderID'],row['CustomerID'],row['EmployeeID'],row['OrderDate'],row['RequiredDate'],row['ShippedDate'],row['ShipVia'],row['Freight'],row['ShipName'],row['ShipAddress'],row['ShipCity'],row['ShipRegion'],row['ShipPostalCode'],row['ShipCountry']) 
		cursor.commit()

# df_Orders = pd.read_excel("data_source.xlsx", sheet_name ='Orders', header = 0)
# df_Orders = df_Orders.where(pd.notnull(df_Orders), None)
# populate_table_Orders(cursor_ER, 'Orders', df_Orders)


# Products
def populate_table_Products(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([ProductID],[ProductName],[SupplierID],[CategoryID],[QuantityPerUnit],[UnitPrice],[UnitsInStock],[UnitsOnOrder],[ReorderLevel],[Discontinued])
			values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'''.format(table_name),row['ProductID'],row['ProductName'],row['SupplierID'],row['CategoryID'],row['QuantityPerUnit'],row['UnitPrice'],row['UnitsInStock'],row['UnitsOnOrder'],row['ReorderLevel'],row['Discontinued']) 
		cursor.commit()

# df_Products = pd.read_excel("data_source.xlsx", sheet_name ='Products', header = 0)
# df_Products = df_Products.where(pd.notnull(df_Products), None)
# populate_table_Products(cursor_ER, 'Products', df_Products)

# OrderDetails

def populate_table_OrderDetails(cursor, table_name, df):
	for index,row in df.iterrows():
		cursor.execute('''INSERT INTO {} ([OrderID],[ProductID],[UnitPrice],[Quantity],[Discount])
			values (?, ?, ?, ?, ?)'''.format(table_name),row['OrderID'],row['ProductID'],row['UnitPrice'],row['Quantity'],row['Discount']) 
		cursor.commit()

# df_OrderDetails = pd.read_excel("data_source.xlsx", sheet_name ='OrderDetails', header = 0)
# df_OrderDetails = df_OrderDetails.where(pd.notnull(df_OrderDetails), None)
# populate_table_OrderDetails(cursor_ER, 'OrderDetails', df_OrderDetails)

# Extract the tables names of the database (excluding system tables)    
def extract_tables_db(cursor, *args):
    results = []
    for x in cursor.execute('exec sp_tables'):
        if x[1] not in args:
            results.append(x[2])
    return results

# Extract the column names of a table given it's name
def extract_table_cols(cursor, table_name):
    result = []
    for row in cursor.columns(table=table_name):
        result.append(row.column_name)
    return result

# A function for finding the primary key of a table
def find_primary_key(cursor, table_name, schema):
    
    # Find the primary key information
    table_primary_key =  cursor.primaryKeys(table_name, schema=schema)
    
    # Store the info about the PK constraint into a dictionary
    columns = [column[0] for column in cursor.description]
    results = []
    for row in cursor.fetchall():
        results.append(dict(zip(columns, row)))
    try:
        return results[0]
    except:
        pass
    return results

def populate_dim_scd1(cursor_src,cursor_dst, 
        src_db, src_table, 
        dst_db, dst_table,connect_col,
        src_schema = 'dbo', dst_schema = 'dbo',):
    
    # Set the proc name
    proc_name = dst_db + '_'+ dst_table + '_SCD_ETL1'

    # Create column lists
    collist_insert = extract_table_cols(cursor_src, src_table)
    collist_src = ["SRC." + i for i in extract_table_cols(cursor_src, src_table)]
    collist_dst = ["DST." + i for i in extract_table_cols(cursor_dst, dst_table)][1:]
    
    # Create a check string list
    check_list = []
    for i,j  in zip(collist_src, collist_dst):
        check_list.append(f"Isnull({j}, '') <> Isnull({i}, '')")
    check_str = " OR ".join(check_list)
 
    # Create a set string list
    set_list = []
    for i,j  in zip(collist_src, collist_dst):
        set_list.append(f"{j} = {i}")
    set_str = ",".join(set_list)

    sql_script_drop_proc = f"""
    DROP PROCEDURE IF EXISTS {proc_name};
    """
    sql_script_create_proc = f"""
    CREATE PROCEDURE {proc_name}
    AS
    BEGIN TRY
    MERGE {dst_db}.{dst_schema}.{dst_table} AS DST 
    USING {src_db}.{src_schema}.{src_table} AS SRC
    ON ( SRC.{connect_col} = DST.{connect_col})
    WHEN NOT MATCHED THEN 
    INSERT ({",".join(collist_insert)})
    VALUES ({",".join(collist_src)})
    WHEN MATCHED AND (
	    {check_str}
        ) 
	THEN
    	UPDATE 
        SET 
            {set_str}; 
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
    """
    
    # Dropping the proc if it exists and commiting the change
    cursor_dst.execute(sql_script_drop_proc)
    cursor_dst.commit()
    
    # Creating a new procedure and committing the change
    cursor_dst.execute(sql_script_create_proc)
    cursor_dst.commit()
    
    # Executing the created procedure
    cursor_dst.execute("exec " + dst_db + '.' + dst_schema + '.' + proc_name + ';')
    cursor_dst.commit()
    
    return f'The {dst_table} table of the {dst_db} database has been populated!'


cursor_DW.close()
cursor_ER.close()
conn_DW.close()
conn_ER.close()

