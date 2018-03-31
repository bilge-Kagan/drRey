/*
GecmisVeri tablosuna yeni kayıtlar yüklendikten sonra bu Procedure çağrılacak.
Burada her hastane için ilgili veriler hesaplanacak ve HastaneGecmisVeris
tablosuna kaydedilecek. Tabi ki yeni dönemID ile..
 */
CREATE PROCEDURE kayıt_hastane_verileri (donemID INTEGER)
  BEGIN
    -- HastaneGecmisVeri sütunları
    DECLARE v_hastane_id INTEGER;
    DECLARE v_hastane_servisi INTEGER;
    DECLARE v_hasta_sayisi INTEGER;
    DECLARE v_rey_kullanan INTEGER;
    DECLARE v_ortalama_rey_puani DECIMAL(7,4);
    DECLARE v_ortalama_memnuniyet DECIMAL(7,4);

    -- Handler değişkeni:
    DECLARE exit_loop_3 BOOLEAN;

    -- Geçici tablonun oluşturulması:
    CREATE TABLE subquery_gecmis_veri(
      c_hastane INTEGER,
      c_hasta_sayisi INTEGER,
      c_rey_kullanan INTEGER,
      c_ortalama_rey_puani DECIMAL(6,3),
      c_ortalama_memnuniyet DECIMAL(6,3)
    );

    -- Hesaplanan GecmisVeri tablosu değerlerinin gecici tabloya
    -- kopyalanması:
    INSERT INTO subquery_gecmis_veri(c_hastane, c_hasta_sayisi, c_rey_kullanan, c_ortalama_rey_puani, c_ortalama_memnuniyet)
      SELECT hastane_id, SUM(hasta_sayisi), SUM(rey_kullanan), SUM(rey_puani) / SUM(GREATEST(rey_kullanan,1)), SUM(memnuniyet) / SUM(GREATEST(rey_kullanan,1))
      FROM gecmis_veris WHERE donem_id = donemID GROUP BY hastane_id;

    -- Nested BEGIN.. END
    BEGIN
      -- Cursor Tanımlanması:
      DECLARE sub_gecmis_veri CURSOR FOR
        SELECT c_hastane, c_hasta_sayisi, c_rey_kullanan, c_ortalama_rey_puani, c_ortalama_memnuniyet
      FROM subquery_gecmis_veri;

      -- Handler Tanımlanması:
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop_3 = TRUE ;

      -- LOOP
      OPEN sub_gecmis_veri;
      subquery_table: LOOP
        FETCH sub_gecmis_veri
          INTO v_hastane_id, v_hasta_sayisi, v_rey_kullanan, v_ortalama_rey_puani, v_ortalama_memnuniyet;

        IF (exit_loop_3 = TRUE) THEN
          CLOSE sub_gecmis_veri;
          LEAVE subquery_table;
        ELSE
          -- GecmisVeri tablosundaki veriler hastaneID' ye göre sınıflandırıldı.
          -- Şimdi de HastaneGecmisVeri tablosuna eklenecekler.
          INSERT INTO hastane_gecmis_veris(hastane_id, donem_id, hasta_sayisi, rey_kullanan, rey_puani, memnuniyet)
            VALUE (v_hastane_id, donemID, v_hasta_sayisi, v_rey_kullanan, v_ortalama_rey_puani, v_ortalama_memnuniyet);
        END IF;

      END LOOP;
    END;
    -- Geçici tablonun silinmesi:
    DROP TABLE subquery_gecmis_veri;

    -- İlgili dönemin kayıtları GecmisVeri tablosundan alınıp, HastaneGecmisVeri tablosuna
    -- kayıt edilmiştir. Gerekli hesaplamalar da yapılmıştır. Sonuç olarak ilgili dönemin
    -- verileri hastaneID ile gruplanarak hastanelere ait tüm verilerin bulunduğu tabloya
    -- eklenmiştir. Bu aşamadan sonra Hastane Bazında, İlçe Bazında, İl Bazında ve
    -- Ülke Bazında veriler hesaplanıp, ilgili tabloların kayıtları güncellenecektir.
    CALL hastane_bazinda_hesaplama(donemID);
  END;