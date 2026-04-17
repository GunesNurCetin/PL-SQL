SmartInventory-PLSQL 🚀
SmartInventory, Oracle PL/SQL kullanılarak geliştirilmiş, gerçek zamanlı bir envanter yönetim ve dinamik fiyatlandırma sistemidir. Bu proje, iş mantığının (business logic) doğrudan veritabanı seviyesinde nasıl kurgulanabileceğini gösterir.



📌 Özellikler (Features)
Dynamic Pricing (Dinamik Fiyatlandırma): Stok miktarı kritik eşiğin altına düştüğünde, sistem arz-talep dengesini korumak için ürün fiyatlarını otomatik olarak %10 artırır.

Audit Logging (Denetim Kaydı): Fiyatlardaki tüm değişimler, eski ve yeni değerleriyle birlikte price_history tablosunda otomatik olarak arşivlenir.

Bulk Processing (Toplu İşlem): Yüksek hacimli stok güncellemeleri için FORALL ve BULK COLLECT yapıları kullanılarak performans optimizasyonu sağlanmıştır.

Modular Architecture: Kodlar, bakım kolaylığı için PACKAGE yapısı altında modüler olarak organize edilmiştir.

🛠 Teknik Detaylar (Technical Stack)
RDBMS: Oracle Database

Language: PL/SQL, SQL

Core Concepts: * Row-level Triggers

PL/SQL Packages (Spec & Body)

Transaction Management (Commit/Rollback)

Exception Handling

Collections & Bulk Operations 




Dosya Adı,Açıklama
schema.sql,Tablo yapıları ve kısıtlamaların (constraints) oluşturulması.
trigger.sql,Stok takibi ve otomatik fiyatlandırma tetikleyicisi.
package.sql,Toplu stok yönetimi ve iş mantığı prosedürleri.
test_data.sql,Sistemi test etmek için hazır veriler ve senaryolar.

🚀 Kurulum ve Kullanım (Installation)
SQL araçlarınızdan (SQL Developer, DBeaver vb.) veritabanına bağlanın.

Dosyaları sırasıyla  çalıştırın.

test_data.sql dosyasındaki örnekleri çalıştırarak tetikleyicilerin ve paketlerin nasıl çalıştığını DBMS_OUTPUT panelinden gözlemleyin.

📝 Örnek Senaryo (Case Study)
Eğer bir ürünün stok miktarı, tanımlanan min_threshold değerinin altına düşerse:

Trigger anında devreye girer.

current_price sütunu güncellenir.

price_history tablosuna "Fiyat neden değişti?" sorusunun cevabı niteliğinde bir kayıt düşer.

Geliştirici: [Güneş Nur ÇETİN / @GunesNurCetin ]

Kategori: Software Developer 

