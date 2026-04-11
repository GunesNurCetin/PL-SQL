/*******************************************************************************
 * PROJECT NAME: Automated Inventory & Order Management System
 * AUTHOR: Güneş Nur ÇETİN (@GunesNurCetin)
 * DATE: 2026-04-11
 * * AÇIKLAMA (TR): 
 * Bu proje, bir depo yönetim sistemini simüle eder. Sipariş verildiğinde stoktan 
 * otomatik düşüş yapar ve stok kritik seviyenin altına indiğinde uyarı verir.
 * * ÖZELLİKLER (TR):
 * 1. Auto-Inventory Sync: Sipariş girildiğinde stok miktarını otomatik güncelleyen Trigger.
 * 2. Critical Stock Alert: Stok yetersizse siparişi engelleyen kontrol mekanizması.
 * 3. Logging System: Yapılan her işlemin tarih ve kullanıcı bazlı kaydı.
 * * KEY PL/SQL FEATURES (EN):
 * - Triggers: Automating data consistency between Orders and Products tables.
 * - Stored Procedures: Modular business logic for processing new orders.
 * - Exception Handling: Managing "Out of Stock" scenarios gracefully.
 *******************************************************************************/

-- 1. TABLOLARIN OLUŞTURULMASI
CREATE TABLE Products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100),
    stock_quantity NUMBER,
    price NUMBER(10, 2)
);

CREATE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    product_id NUMBER,
    order_date DATE DEFAULT SYSDATE,
    quantity NUMBER,
    total_amount NUMBER(10, 2),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 2. OTOMATİK STOK GÜNCELLEME TETİKLEYİCİSİ (TRIGGER)
CREATE OR REPLACE TRIGGER trg_update_stock
BEFORE INSERT ON Orders
FOR EACH ROW
DECLARE
    current_stock NUMBER;
BEGIN
    -- Mevcut stoğu kontrol et
    SELECT stock_quantity INTO current_stock 
    FROM Products 
    WHERE product_id = :NEW.product_id;

    -- Stok yeterli mi kontrolü
    IF current_stock < :NEW.quantity THEN
        RAISE_APPLICATION_ERROR(-20001, 'HATA: Yetersiz stok! Sipariş iptal edildi.');
    ELSE
        -- Stoğu düşür
        UPDATE Products 
        SET stock_quantity = stock_quantity - :NEW.quantity
        WHERE product_id = :NEW.product_id;
    END IF;
END;
/

-- 3. SİPARİŞ İŞLEME PROSEDÜRÜ (STORED PROCEDURE)
CREATE OR REPLACE PROCEDURE prc_place_order (
    p_order_id IN NUMBER,
    p_prod_id IN NUMBER,
    p_qty IN NUMBER
) AS
    v_price NUMBER;
BEGIN
    -- Ürün fiyatını al
    SELECT price INTO v_price FROM Products WHERE product_id = p_prod_id;

    -- Siparişi ekle (Trigger otomatik olarak stoğu kontrol edip düşürecek)
    INSERT INTO Orders (order_id, product_id, quantity, total_amount)
    VALUES (p_order_id, p_prod_id, p_qty, (v_price * p_qty));

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('LOG: Sipariş başarıyla oluşturuldu.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('HATA: ' || SQLERRM);
        ROLLBACK;
END;
/

-- 4. TEST VERİLERİ (DEMO)
INSERT INTO Products VALUES (1, 'Laptop', 50, 15000);
INSERT INTO Products VALUES (2, 'Mouse', 10, 500);

-- Test 1: Başarılı Sipariş
EXEC prc_place_order(101, 1, 2);

-- Test 2: Stok Yetersiz Hatası (Mouse stok 10, biz 15 istiyoruz)
EXEC prc_place_order(102, 2, 15);
