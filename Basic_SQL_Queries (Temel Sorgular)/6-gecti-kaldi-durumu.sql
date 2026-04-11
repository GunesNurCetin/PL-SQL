-- 6. SONUÇLARI GÖRÜNTÜLE
SELECT o.ad, o.soyad, n.ders_adi, n.ortalama, n.durum
FROM ogrenciler o
JOIN notlar n ON o.ogrenci_id = n.ogrenci_id;
