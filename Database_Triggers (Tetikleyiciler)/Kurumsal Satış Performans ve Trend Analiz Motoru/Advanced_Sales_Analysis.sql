/* PROJECT: Advanced Sales & Inventory Insight (Analytical SQL)
   DESCRIPTION: CTE ve Window Functions kullanarak kategorik ciro analizi 
                ve stok durum raporlaması.
*/

WITH Kategori_Analiz_CTE AS (
    SELECT 
        k.kategori_adi,
        u.urun_adi,
        u.stok_miktari,
        SUM(s.miktar) as toplam_adet,
        SUM(s.miktar * u.birim_fiyat) as toplam_ciro,
        -- Her kategoride ciroya göre ürünleri sırala
        RANK() OVER (PARTITION BY k.kategori_id ORDER BY SUM(s.miktar * u.birim_fiyat) DESC) as kategori_sira
    FROM Urunler u
    INNER JOIN Kategoriler k ON u.kategori_id = k.kategori_id
    LEFT JOIN Satislar s ON u.urun_id = s.urun_id
    GROUP BY k.kategori_adi, u.urun_adi, u.stok_miktari, k.kategori_id
)
SELECT 
    kategori_adi,
    urun_adi,
    toplam_ciro || ' TL' as ciro_formatli,
    toplam_adet as satilan_adet,
    -- Analitik Karar Mekanizması
    CASE 
        WHEN stok_miktari < 10 AND kategori_sira <= 2 THEN 'ACİL: POPÜLER ÜRÜN - STOK KRİTİK'
        WHEN kategori_sira = 1 THEN 'KATEGORİ LİDERİ'
        ELSE 'STOK NORMAL'
    END as operasyonel_durum,
    -- Kategorideki toplam cironun yüzde kaçı bu üründen geliyor?
    ROUND(100 * toplam_ciro / SUM(toplam_ciro) OVER (PARTITION BY kategori_adi), 2) || '%' as kategori_ciro_payi
FROM Kategori_Analiz_CTE
ORDER BY kategori_adi, kategori_sira;
