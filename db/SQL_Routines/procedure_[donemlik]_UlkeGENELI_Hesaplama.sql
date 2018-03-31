/*
Ülke geneli hesaplamada HastaneGecmisVeris tablosu kullanılacaktır.
Her dönem aynı satırı günccelemek yerine dönemlik olarak yeni bir satır
eklenecektir. Bu tablo atacılığıyla ülke geneli olan durum
her defasında yeniden hesaplamak zorunda kalmadan istenilen anda
gözlenebilecektir.
Dönemlik olarak hesaplanacak bu tablo SQL içerisine gömülen bir program yardımı
ile yapılacağı için sistemi neredeyse hiç yormadan ve hiçbir aksamaya yer
vermeden gerçekleştirilecektir.
 */
CREATE PROCEDURE ulke_geneli_hesaplama()
  -- Bu procedure içerisinde cursor oluşturmaya ihtiyaç duyulmamıştır.
  BEGIN
    -- İlgili DonemID:
    DECLARE v_donem_id INTEGER;

    -- Ulke Verileri tablosu değişkenleri
    DECLARE v_hasta_sayisi INTEGER;
    DECLARE v_rey_kullanan_sayisi INTEGER;
    DECLARE v_rey_puani DECIMAL(7,4);
    DECLARE v_memnuniyet DECIMAL(7,4);

    -- İlgili dönemde hesaplamada kullanılan BazPuan
    -- Ülke tablosunda bazPuan verileri incelenerek ülke geneli
    -- sağlık kalitesinin durumu hakkında da bilgi alınabilir.
    DECLARE v_doneme_ait_baz_puan DECIMAL(7,4);

    -- DonemId
    SELECT id INTO v_donem_id
      FROM donems
    ORDER BY id DESC LIMIT 1,1;

    -- BazPuan
    SELECT rey_puani INTO v_doneme_ait_baz_puan
    FROM baz_puans WHERE id = 1;

    -- HastaneGecmisVeris tablosundan ilgili döneme ait verilerin
    -- hesaplanarak çekilmesi:
    SELECT SUM(hasta_sayisi), SUM(rey_kullanan), SUM(rey_puani) / COUNT(id), SUM(memnuniyet) / COUNT(id)
      INTO v_hasta_sayisi, v_rey_kullanan_sayisi, v_rey_puani, v_memnuniyet
    FROM hastane_gecmis_veris
      WHERE donem_id = v_donem_id;

    -- Yeni kayıtların ülke tablosuna eklenmesi:
    INSERT INTO ulke_gecmis_veris(donem_id, hasta_sayisi, rey_kullanan, rey_puani, memnuniyet, baz_puan)
      VALUE (v_donem_id, v_hasta_sayisi, v_rey_kullanan_sayisi, v_rey_puani, v_memnuniyet, v_doneme_ait_baz_puan);

    -- Bu verinin eklenmesi ile DÖNEMLİK hesaplama zincirlemesi son bulmaktadır.
  END;