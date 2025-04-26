/***********************
 Basic Filtering & Sorting
************************/
-- Recent delivered orders (2023)
SELECT order_id, customer_id, order_date 
FROM orders
WHERE order_date BETWEEN '2023-01-01' AND '2023-12-31'
  AND status = 'delivered'
ORDER BY order_date DESC
LIMIT 10;

/***********************
 Sales Performance Analysis 
************************/
-- Category-wise sales breakdown
SELECT c.category_name, 
       SUM(oi.quantity * oi.price) AS total_sales,
       AVG(oi.quantity * oi.price) AS avg_order_value
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_sales DESC;

/***********************
 Customer Insights 
************************/
-- Top 10 customers by spending
CREATE VIEW top_customers AS
SELECT c.customer_id, c.name, 
       SUM(oi.quantity * oi.price) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC
LIMIT 10;

/***********************
 Inventory Management 
************************/
-- Stock alert subquery
SELECT product_id, name, 
       stock_quantity AS current_stock,
       (SELECT AVG(stock_quantity) FROM products) AS avg_stock
FROM products
WHERE stock_quantity < 20;

/***********************
 Index Optimization
************************/
CREATE INDEX idx_order_date_status ON orders(order_date, status);
CREATE INDEX idx_product_pricing ON products(category_id, price);
