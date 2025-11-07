-- 3. YENİ ÖĞRENCİ EKLEME (PROCEDURE)
CREATE OR REPLACE PROCEDURE ogrenci_ekle (
    p_ad IN VARCHAR2,
    p_soyad IN VARCHAR2,
    p_bolum IN VARCHAR2
) AS
BEGIN
    INSERT INTO ogrenciler (ad, soyad, bolum)
    VALUES (p_ad, p_soyad, p_bolum);
    DBMS_OUTPUT.PUT_LINE('Yeni öğrenci eklendi: ' || p_ad || ' ' || p_soyad);
END;
/
