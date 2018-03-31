/*
Her ayın 18. günü, saat 03:55 te DonemlikBasari tablosundaki veriler
GecmisVeri tablosuna eklenecek. Böylece bir sıra hesaplama procedure
çağrılacak.
Bu tarihten sonra zaman aşımına uğrayan hastaların da Rey kullanım hakları
kalmadığı için DonemlikBasaris tablosunda herhangi bir değişiklik olmayacak.

Ödüller ve cezalar da bu tarihten sonra hesaplanmış olacaktır.
 */
CREATE PROCEDURE donemlik_basarim_kopyalama ()
  BEGIN
    DECLARE v_basarim_tablosu_donem_id INTEGER;
    DECLARE v_baz_puan DECIMAL(7,4);

    -- DonemlikBasarim Verileri (Bunlar LOOP içinde GecmisVeri tablosuna kopyalanacak)
    DECLARE v_doktor_id INTEGER;
    DECLARE v_hastane_id INTEGER;
    DECLARE v_hastane_servisi INTEGER;
    DECLARE v_hasta_sayisi INTEGER;
    DECLARE v_rey_kullanan INTEGER;
    DECLARE v_rey_puani DECIMAL(7,4);
    DECLARE v_memnuniyet DECIMAL(7,4);

    -- Handler değişkeni:
    DECLARE exit_loop_2 BOOLEAN;

    -- GecmisVeri Değişkenleri::
    DECLARE v_band INTEGER;
    DECLARE v_alt_band DECIMAL(7,4);
    DECLARE v_ust_band DECIMAL(7,4);

    -- DonemlikBasari Cursor
    DECLARE donemlik_basari_cursor CURSOR FOR
      SELECT dktr_id, hastane_id, hastane_servisi, hasta_sayisi, rey_kullanan, rey_puani, memnuniyet
        FROM donemlik_basaris;

    -- Handler
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop_2 = TRUE;

    -- Basarim tablosu DonemID:
    SELECT id INTO v_basarim_tablosu_donem_id FROM donems
      ORDER BY id DESC LIMIT 1,1;

    -- BazPuan
    SELECT rey_puani INTO v_baz_puan FROM baz_puans WHERE id = 1;

    -- Alt ve Üst Band Hesaplamaları
    -- Band Puanlarının nasıl hesaplandığı Proje Belgesinde Açıklandı
    SET v_ust_band = (((100 - v_baz_puan) * 7) / 10) + v_baz_puan;
    SET v_alt_band = v_baz_puan -  ((v_baz_puan * 7) / 10);

    -- LOOP
    OPEN donemlik_basari_cursor;
    donemlik_basaris: LOOP
      FETCH donemlik_basari_cursor
        INTO v_doktor_id, v_hastane_id, v_hastane_servisi, v_hasta_sayisi, v_rey_kullanan, v_rey_puani, v_memnuniyet;

      IF (exit_loop_2 = TRUE) THEN
        CLOSE donemlik_basari_cursor;
        LEAVE donemlik_basaris;
      ELSE
        -- Band Aralığının bulunması:
        IF v_rey_puani > v_ust_band THEN
          SET v_band = 1;
        ELSEIF (v_rey_puani <> 0) AND (v_rey_puani < v_alt_band) THEN
          SET  v_band = -1;
        ELSEIF v_rey_puani = 0 THEN
          SET v_band = 0;
        ELSE
          SET v_band = 0;
        END IF;

        -- Değerlerin GecmisVeri Tablosuna eklenmesi (DonemID ile):
        INSERT INTO gecmis_veris(dktr_id, hastane_id, hastane_servisi, donem_id, hasta_sayisi, rey_kullanan,
                                 rey_puani, memnuniyet, band)
          VALUE (v_doktor_id, v_hastane_id, v_hastane_servisi, v_basarim_tablosu_donem_id, v_hasta_sayisi, v_rey_kullanan,
                  v_rey_puani, v_memnuniyet, v_band);
      END IF;

    END LOOP;
    -- DonemlikBasari tablosunda bulunan tüm kayıtlar GecmisVeri tablosuna aktarıldıktan
    -- sonra, GecmisVeri tablosundaki veriler, HastaneGecmisVeri tablosuna aktarılacak.
    -- Bu bölümden sonraki kayıtlar "zincirleme fonksiyon" tasarımı ile hesaplanacak ve
    -- kayıt altına alınacaktır.
    CALL kayit_hastane_verileri(v_basarim_tablosu_donem_id);

  END;