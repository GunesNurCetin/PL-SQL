-- 5. ORTALAMA VE DURUM GÜNCELLEME
CREATE OR REPLACE PROCEDURE durum_guncelle AS
BEGIN
    FOR r IN (SELECT not_id, ortalama FROM notlar) LOOP
        IF r.ortalama >= 60 THEN
            UPDATE notlar SET durum = 'GEÇTİ' WHERE not_id = r.not_id;
        ELSE
            UPDATE notlar SET durum = 'KALDI' WHERE not_id = r.not_id;
        END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Durumlar başarıyla güncellendi.');
END;
/
