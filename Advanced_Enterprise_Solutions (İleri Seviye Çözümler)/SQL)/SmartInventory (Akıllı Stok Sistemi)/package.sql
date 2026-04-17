CREATE OR REPLACE PACKAGE pkg_inventory_mgmt AS
    -- Toplu işlem için dizi tipi tanımlama
    TYPE t_prod_ids IS TABLE OF NUMBER;
    
    -- Toplu stok ekleme prosedürü
    PROCEDURE restock_bulk(p_ids IN t_prod_ids, p_amount IN NUMBER);
END pkg_inventory_mgmt;
/

CREATE OR REPLACE PACKAGE BODY pkg_inventory_mgmt AS
    PROCEDURE restock_bulk(p_ids IN t_prod_ids, p_amount IN NUMBER) IS
    BEGIN
        -- Yüksek performans için toplu güncelleme (Bulk Update)
        FORALL i IN 1..p_ids.COUNT
            UPDATE products 
            SET stock_quantity = stock_quantity + p_amount
            WHERE product_id = p_ids(i);
            
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(p_ids.COUNT || ' adet ürün başarıyla güncellendi.');
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('HATA: İşlem sırasında bir sorun oluştu -> ' || SQLERRM);
    END restock_bulk;
END pkg_inventory_mgmt;
/


## Toplu işlemler ve yönetimsel fonksiyonlar bu pakette toplanır. GitHub'da profesyonelliği bu kısım gösterir.
