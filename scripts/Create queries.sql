---- Create the Products table with a foreign key reference to Materials

CREATE TABLE products (
	product_id INTEGER PRIMARY KEY,
	product_name CHARACTER VARYING (25),
	product_price INTEGER NOT NULL,
	product_description CHARACTER VARYING (50),
	material_id INTEGER NOT NULL,
FOREIGN KEY (material_id) REFERENCES materials (material_id) ON UPDATE CASCADE ON DELETE CASCADE

);

---- Create the Orders table with a foreign key reference to Products

CREATE TABLE orders (
	order_id INTEGER PRIMARY KEY,
	customer_name CHARACTER VARYING (25),
	order_date DATE NOT NULL,
	order_status CHARACTER VARYING (25),
	product_id INTEGER NOT NULL,
FOREIGN KEY (product_id) REFERENCES products (product_id) ON UPDATE CASCADE ON DELETE CASCADE
);

---- Create the Suppliers table with a foreign key reference to Products

CREATE TABLE suppliers (
	supplier_id INTEGER PRIMARY KEY,
	supplier_name CHARACTER VARYING (50),
	phone_number TEXT,
	supplier_address CHARACTER VARYING (50),
	product_id INTEGER NOT NULL,
FOREIGN KEY (product_id) REFERENCES products (product_id) ON UPDATE CASCADE ON DELETE CASCADE

);

---- Create the Materials table

CREATE TABLE materials (
	material_id INTEGER PRIMARY KEY,
	material_name CHARACTER VARYING (55),
	material_price INTEGER NOT NULL,
	material_description CHARACTER VARYING (150)
);
