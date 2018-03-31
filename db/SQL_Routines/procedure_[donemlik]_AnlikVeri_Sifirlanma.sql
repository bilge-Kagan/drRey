/*
Her ayın 14. günü, saat 03.55 te anlik_veri tablosu sıfırlanacak.
Burada bulunan veriler donemlik_basarim tablosuna kopyalanacak.
Donem tablosuna yeni bir dönem eklenecek.

Burada tanımlanacak procedure bir EVENT yardımı ile belirtilen tarihte
çağrılacak.
 */
CREATE PROCEDURE anlik_veri_sifirlanma ()
  BEGIN
    DECLARE v_eski_donem_hasta_sayisi INTEGER DEFAULT 0;
    DECLARE v_eski_rey_puani DECIMAL(7,4) DEFAULT 0;

    -- AnlikVeri tablosu verileri:
    DECLARE v_doktor_id INTEGER;
    DECLARE v_hastane_id INTEGER;
    DECLARE v_hastane_servisi INTEGER;
    DECLARE v_hasta_sayisi INTEGER;
    DECLARE v_rey_puani DECIMAL(7,4);
    DECLARE v_rey_kullanan INTEGER;
    DECLARE v_memnuniyet DECIMAL(7,4);
    DECLARE v_hasta_sayisi_degisimi DECIMAL(7,4);
    DECLARE v_rey_puani_degisimi DECIMAL(7,4);

    -- Handler variable
    DECLARE exit_loop_1 BOOLEAN;

    -- Cursor ve Handler Tanımlaması
    DECLARE anlik_veri_cursor CURSOR FOR
      SELECT dktr_id, hastane_id, hastane_servisi, hasta_sayisi, rey_kullanan, rey_puani, memnuniyet
        FROM anlik_veris;

    -- handler:
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop_1 = TRUE ;

    -- DonemlikBasari için geçici bir tablo oluşturulacak:
      CREATE TABLE copy_donemlik_basaris LIKE donemlik_basaris;
      INSERT INTO copy_donemlik_basaris(id, dktr_id, hastane_id, hastane_servisi, hasta_sayisi, rey_kullanan, rey_puani, hasta_sayisi_degisim, rey_puani_degisim, memnuniyet)
        SELECT id, dktr_id, hastane_id, hastane_servisi, hasta_sayisi, rey_kullanan, rey_puani, hasta_sayisi_degisim, rey_puani_degisim, memnuniyet
        FROM donemlik_basaris;
      TRUNCATE TABLE donemlik_basaris;

    -- LOOP
    OPEN anlik_veri_cursor;
    anlik_veri: LOOP
      FETCH anlik_veri_cursor
        INTO v_doktor_id, v_hastane_id, v_hastane_servisi, v_hasta_sayisi, v_rey_kullanan, v_rey_puani, v_memnuniyet;

      IF (exit_loop_1 = TRUE) THEN
        CLOSE anlik_veri_cursor;
        LEAVE anlik_veri;
      ELSE
        IF (SELECT EXISTS(SELECT id FROM copy_donemlik_basaris WHERE dktr_id = v_doktor_id AND hastane_id = v_hastane_id)) THEN
          SELECT hasta_sayisi, rey_puani INTO v_eski_donem_hasta_sayisi, v_eski_rey_puani
            FROM copy_donemlik_basaris WHERE dktr_id = v_doktor_id AND hastane_id = v_hastane_id;

          -- Hesaplama::
          SET v_hasta_sayisi_degisimi = ((v_hasta_sayisi - v_eski_donem_hasta_sayisi) / v_eski_donem_hasta_sayisi) * 100;
          SET v_rey_puani_degisimi = ((v_rey_puani - v_eski_rey_puani) / v_eski_rey_puani) * 100;

          -- INSERT DonemlikBasari::
          INSERT INTO donemlik_basaris(dktr_id, hastane_id, hastane_servisi, hasta_sayisi, rey_kullanan,
                                       rey_puani, hasta_sayisi_degisim, rey_puani_degisim, memnuniyet)
            VALUE (v_doktor_id, v_hastane_id, v_hastane_servisi, v_hasta_sayisi, v_rey_kullanan, v_rey_puani,
                   v_hasta_sayisi_degisimi, v_rey_puani_degisimi, v_memnuniyet);
        ELSE
          -- DonemlikBasaris tablosunda doktorID ilgili bulunazmaz ise, doktorun bir önceki döneme ait kayıdı
          -- yok demektir. Bu sebeple "hasta_sayisi_degisim" ve "rey_puani_degisim" değerleri NULL girilecektir.

          INSERT INTO donemlik_basaris(dktr_id, hastane_id, hastane_servisi, hasta_sayisi, rey_kullanan,
                                       rey_puani, memnuniyet)
            VALUE (v_doktor_id, v_hastane_id, v_hastane_servisi, v_hasta_sayisi, v_rey_kullanan, v_rey_puani, v_memnuniyet);
        END IF;
      END IF;
    END LOOP;
    -- <copy_donemlik_basaris> tablosu silinecek ve <anlik_veris> tablosu sıfırlanacaktır.
    DROP TABLE copy_donemlik_basaris;
    TRUNCATE TABLE anlik_veris;

    -- Donem tablosuna yeni dönem eklenecektir.
    CALL yeni_donem();

  END;