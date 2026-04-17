CREATE OR REPLACE TRIGGER trg_stock_price_adjust
BEFORE UPDATE OF stock_quantity ON products
FOR EACH ROW
WHEN (NEW.stock_quantity <> OLD.stock_quantity)
BEGIN
    -- Stok kritik eşiğin altına düşerse fiyatı otomatik %10 artır (Arz-Talep Mantığı)
    IF :NEW.stock_quantity < :NEW.min_threshold AND :NEW.stock_quantity < :OLD.stock_quantity THEN
        :NEW.current_price := :OLD.current_price * 1.10;
        
        -- Değişimi tarihçe tablosuna kaydet
        INSERT INTO price_history (product_id, old_price, new_price)
        VALUES (:OLD.product_id, :OLD.current_price, :NEW.current_price);
        
        DBMS_OUTPUT.PUT_LINE('UYARI: ' || :OLD.product_name || ' stok kritik seviyede! Fiyat güncellendi.');
    END IF;
END;
/



## Stok düştüğünde fiyatı otomatik artıran "akıllı" kısım burasıdır.
