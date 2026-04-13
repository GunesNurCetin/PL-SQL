-- 1. Günlüklerin tutulacağı Log tablosu
CREATE TABLE Fiyat_Log (
    log_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    urun_id NUMBER,
    eski_fiyat NUMBER,
    yeni_fiyat NUMBER,
    degisiklik_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    kullanici VARCHAR2(50)
);

-- 2. Tetikleyici (Trigger) - Fiyat değişimini izler
CREATE OR REPLACE TRIGGER TRG_Fiyat_Izle
AFTER UPDATE OF urun_fiyati ON Urunler
FOR EACH ROW
BEGIN
    -- Sadece fiyat gerçekten değiştiyse kayıt yap
    IF :OLD.urun_fiyati <> :NEW.urun_fiyati THEN
        INSERT INTO Fiyat_Log (
            urun_id, 
            eski_fiyat, 
            yeni_fiyat, 
            kullanici
        ) VALUES (
            :OLD.urun_id, 
            :OLD.urun_fiyati, 
            :NEW.urun_fiyati, 
            USER
        );
    END IF;
END;
/





