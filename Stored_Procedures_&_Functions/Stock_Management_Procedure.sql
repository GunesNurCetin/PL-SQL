-- 1. Tablo Yapıları (Case Study için temel)
CREATE TABLE Urunler (
    urun_id NUMBER PRIMARY KEY,
    urun_adi VARCHAR2(100),
    stok_miktari NUMBER
);

CREATE TABLE Siparisler (
    siparis_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    urun_id NUMBER,
    miktar NUMBER,
    siparis_tarihi DATE DEFAULT SYSDATE,
    FOREIGN KEY (urun_id) REFERENCES Urunler(urun_id)
);

-- 2. Ana İşlem Fonksiyonu (Stored Procedure)
CREATE OR REPLACE PROCEDURE Siparis_Isle(
    p_urun_id IN NUMBER,
    p_miktar IN NUMBER
) AS
    v_mevcut_stok NUMBER;
BEGIN
    -- Stok kontrolü yap
    SELECT stok_miktari INTO v_mevcut_stok 
    FROM Urunler 
    WHERE urun_id = p_urun_id;

    IF v_mevcut_stok >= p_miktar THEN
        -- Stok yeterliyse siparişi kaydet
        INSERT INTO Siparisler (urun_id, miktar) VALUES (p_urun_id, p_miktar);
        
        -- Stok miktarını güncelle
        UPDATE Urunler 
        SET stok_miktari = stok_miktari - p_miktar 
        WHERE urun_id = p_urun_id;
        
        DBMS_OUTPUT.PUT_LINE('Sipariş başarıyla tamamlandı.');
    ELSE
        -- Stok yetersizse hata fırlat
        DBMS_OUTPUT.PUT_LINE('Hata: Yetersiz stok! Mevcut: ' || v_mevcut_stok);
    END IF;
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Hata: Ürün bulunamadı!');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Beklenmedik bir hata oluştu.');
END;
/
