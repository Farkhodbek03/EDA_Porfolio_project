
-- Mint Classics Company (EDA) Project by Frakhod 


-- List All Products and Their Warehouse Locations

SELECT 
    p.productCode,
    p.productName,
    p.quantityInStock,
    w.warehouseCode,
    w.warehouseName
FROM 
    products p
JOIN 
    warehouses w ON p.warehouseCode = w.warehouseCode;
 
    
    -- Identify Underutilized Warehouses
    
    
    SELECT 
    w.warehouseCode,
    w.warehouseName,
    SUM(p.quantityInStock) AS totalInventory
FROM 
    products p
JOIN 
    warehouses w ON p.warehouseCode = w.warehouseCode
GROUP BY 
    w.warehouseCode, w.warehouseName
ORDER BY 
    totalInventory ASC;
    
    
    -- Compare Inventory Levels with Sales
    
    SELECT 
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS totalSold,
    p.quantityInStock AS currentInventory
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode, p.productName, p.quantityInStock
ORDER BY 
    totalSold DESC;
    
    
    -- Slow-Moving or Non-Moving Products
    
    SELECT 
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS totalSold,
    p.quantityInStock AS currentInventory
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode, p.productName, p.quantityInStock
HAVING 
    totalSold IS NULL OR totalSold = 0
ORDER BY 
    currentInventory DESC;
    
    -- Inventory Turnover Ratio; This query calculates the inventory turnover ratio, 
    -- which measures how quickly inventory is sold and replaced.
    
    SELECT 
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS totalSold,
    p.quantityInStock AS currentInventory,
    ROUND(SUM(od.quantityOrdered) / p.quantityInStock, 2) AS inventoryTurnoverRatio
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode, p.productName, p.quantityInStock
ORDER BY 
    inventoryTurnoverRatio ASC;
    
    
    -- List Products with High Inventory but Low Sales
    
    
    SELECT 
    p.productCode,
    p.productName,
    p.quantityInStock AS currentInventory,
    SUM(od.quantityOrdered) AS totalSold
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode, p.productName, p.quantityInStock
HAVING 
    totalSold < p.quantityInStock * 0.1  
ORDER BY 
    currentInventory DESC;
    
    
    --  Consolidate Inventory for Potential Warehouse Closure
    
    
    SELECT 
    p.productCode,
    p.productName,
    p.quantityInStock,
    w.warehouseName,
    w2.warehouseName AS suggestedWarehouse
FROM 
    products p
JOIN 
    warehouses w ON p.warehouseCode = w.warehouseCode
JOIN 
    warehouses w2 ON w2.warehouseCode <> w.warehouseCode
WHERE 
    w.warehousePctCap < 50  
    
ORDER BY 
    p.quantityInStock DESC;
    
    

    -- Analyze Sales Data
    
    
    SELECT p.productCode, p.productName, SUM(od.quantityOrdered) AS totalSold
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName
ORDER BY totalSold DESC;


-- Storage Locations


SELECT warehouseCode, COUNT(productCode) AS numProducts, SUM(quantityInStock) AS totalInventory
FROM products
GROUP BY warehouseCode;


-- Thank you for much, This is 