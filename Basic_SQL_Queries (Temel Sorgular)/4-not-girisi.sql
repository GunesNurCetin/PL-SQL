-- 4. NOT GİRİŞİ PROSEDÜRÜ
CREATE OR REPLACE PROCEDURE not_gir (
    p_ogrenci_id IN NUMBER,
    p_ders_adi IN VARCHAR2,
    p_vize IN NUMBER,
    p_final IN NUMBER
) AS
    v_ortalama NUMBER;
BEGIN
    v_ortalama := (p_vize * 0.4) + (p_final * 0.6);
    INSERT INTO notlar (ogrenci_id, ders_adi, vize, final, ortalama)
    VALUES (p_ogrenci_id, p_ders_adi, p_vize, p_final, v_ortalama);
    DBMS_OUTPUT.PUT_LINE('Not girişi başarılı. Ortalama: ' || v_ortalama);
END;
/
