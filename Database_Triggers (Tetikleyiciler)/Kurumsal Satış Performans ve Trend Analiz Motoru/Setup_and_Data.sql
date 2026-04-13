/* PROJECT: Data Source Setup for Sales Analytics
   DESCRIPTION: Veri analizi için gerekli tabloların oluşturulması ve 
                örnek kurumsal verilerin (Seed Data) yüklenmesi.
*/

-- Tabloların temizlenmesi (Varsa)
DROP TABLE Satislar;
DROP TABLE Urunler;
DROP TABLE Kategoriler;

-- 1. Kategoriler Tablosu
CREATE TABLE Kategoriler (
    kategori_id NUMBER PRIMARY KEY,
    kategori_adi VARCHAR2(50) NOT NULL
);

-- 2. Ürünler Tablosu (Fiyat ve Stok Verisi Buradan Gelir)
CREATE TABLE Urunler (
    urun_id NUMBER PRIMARY KEY,
    urun_adi VARCHAR2(100) NOT NULL,
    kategori_id NUMBER,
    birim_fiyat NUMBER(10,2) NOT NULL,
    stok_miktari NUMBER DEFAULT 0,
    CONSTRAINT fk_kategori FOREIGN KEY (kategori_id) REFERENCES Kategoriler(kategori_id)
);

-- 3. Satışlar Tablosu (Hareketli Veri Buradan Gelir - OLTP)
CREATE TABLE Satislar (
    satis_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    urun_id NUMBER,
    miktar NUMBER NOT NULL,
    satis_tarihi DATE DEFAULT SYSDATE,
    CONSTRAINT fk_urun FOREIGN KEY (urun_id) REFERENCES Urunler(urun_id)
);

-- ÖRNEK KURUMSAL VERİLERİN YÜKLENMESİ
BEGIN
    -- Kategoriler
    INSERT INTO Kategoriler VALUES (1, 'Elektronik');
    INSERT INTO Kategoriler VALUES (2, 'Beyaz Eşya');
    INSERT INTO Kategoriler VALUES (3, 'Aksesuar');

    -- Ürünler (Bazılarını özellikle düşük stoklu yapıyoruz ki analizde çıksın)
    INSERT INTO Urunler VALUES (101, 'Amiral Gemisi Telefon', 1, 45000, 5);  -- Kritik Stok
    INSERT INTO Urunler VALUES (102, 'Buzdolabı', 2, 32000, 20);
    INSERT INTO Urunler VALUES (103, 'Kablosuz Kulaklık', 3, 4500, 100);
    INSERT INTO Urunler VALUES (104, 'Akıllı Saat', 1, 12000, 2);          -- Kritik Stok
    INSERT INTO Urunler VALUES (105, 'Laptop', 1, 55000, 15);

    -- Satış Hareketleri (Rastgele Satışlar)
    INSERT INTO Satislar (urun_id, miktar) VALUES (101, 10);
    INSERT INTO Satislar (urun_id, miktar) VALUES (101, 5);
    INSERT INTO Satislar (urun_id, miktar) VALUES (102, 3);
    INSERT INTO Satislar (urun_id, miktar) VALUES (103, 50);
    INSERT INTO Satislar (urun_id, miktar) VALUES (104, 8);
    INSERT INTO Satislar (urun_id, miktar) VALUES (105, 4);
    
    COMMIT;
END;
/
