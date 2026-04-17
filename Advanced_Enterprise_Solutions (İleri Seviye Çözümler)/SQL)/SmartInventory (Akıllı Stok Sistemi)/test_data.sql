-- Örnek ürünler ekleyelim
INSERT INTO products (product_id, product_name, stock_quantity, base_price, current_price, min_threshold)
VALUES (101, 'Kablosuz Mouse', 15, 200, 200, 5);

INSERT INTO products (product_id, product_name, stock_quantity, base_price, current_price, min_threshold)
VALUES (102, 'Mekanik Klavye', 6, 800, 800, 8); -- Bu ürün kritik seviyede başlayacak

COMMIT;

-- TEST: Stok düşüşü yapalım ve tetikleyiciyi görelim
UPDATE products SET stock_quantity = 4 WHERE product_id = 102;

-- Sonuçları kontrol edelim
SELECT * FROM products;
SELECT * FROM price_history;


## Test Kısmı 
