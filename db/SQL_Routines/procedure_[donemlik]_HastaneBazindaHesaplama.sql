/*
HastaneGecmisVeri tablosuna veriler eklendikten sonra burada
tanımlanacak olan Procedure çağrılacaktır.
Bu Procedure "Hastane" tablosunda yer alan, her bir hastaneye ait
ortalama ReyPuani, son ReyPuani, Memnuniyet gibi verileri hesaplayacak
ve güncelleme işlemini gerçekleştriecektir.
 */
CREATE PROCEDURE hastane_bazinda_hesaplama (donemID INTEGER)
  BEGIN
    -- Hastane Bazındaki Eski Veri:
    DECLARE v_eski_ortalama_rey_puani DECIMAL(7,4) DEFAULT 0;
    DECLARE v_eski_memnuniyet DECIMAL(7,4) DEFAULT 0;
    DECLARE v_son_rey_puani DECIMAL(7,4) DEFAULT 0;

    -- Güncellenecek Veriler:
    DECLARE v_hastane_id INTEGER;
    DECLARE v_rey_puan_degisimi DECIMAL(7,4);
    DECLARE v_yeni_memnuniyet DECIMAL(7,4);
    DECLARE v_yeni_rey_puani DECIMAL(7,4);

    -- Hesaplama Değişkenleri
    DECLARE v_veri_sayisi INTEGER DEFAULT 1;

    -- Handler değişkeni:
    DECLARE exit_loop_4 BOOLEAN;

    -- İlgili döneme ait hastane verilerini içeren
    -- Gecici Tablonun oluşturuluması
    CREATE TABLE sub_hastane_gecmis_veri(
      c_hastane_id INTEGER,
      c_rey_puani DECIMAL(7,4),
      c_memnuniyet DECIMAL(7,4)
    );

    -- Geçici tabloya verilerin eklenmesi
    INSERT INTO sub_hastane_gecmis_veri(c_hastane_id, c_rey_puani, c_memnuniyet)
      SELECT hastane_id, rey_puani, memnuniyet FROM hastane_gecmis_veris
        WHERE donem_id = donemID;

    -- Nested BEGIN.. END
    BEGIN
      -- Geçici tablo üzerine Cursor oluşturulması
      DECLARE hastane_gecmis_veri_cursor CURSOR FOR
        SELECT c_hastane_id, c_rey_puani, c_memnuniyet
          FROM sub_hastane_gecmis_veri;

      -- Handler:
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop_4 = TRUE ;

      -- LOOP
      OPEN hastane_gecmis_veri_cursor;
      sub_table: LOOP
        FETCH hastane_gecmis_veri_cursor
          INTO v_hastane_id, v_yeni_rey_puani, v_yeni_memnuniyet;

        IF (exit_loop_4 = TRUE) THEN
          CLOSE hastane_gecmis_veri_cursor;
          LEAVE sub_table;
        ELSE
          -- Var olan eski ortalama puanin ve memnuniyetin alınması
          SELECT son_rey_puani, ortalama_rey_puani, memnuniyet
            INTO v_son_rey_puani, v_eski_ortalama_rey_puani, v_eski_memnuniyet
            FROM hastanes
          WHERE id = v_hastane_id;

          -- Hastaneye ait kayıt sayılarının alınması, ancak 1 eksiği. (yeni kayıt hariç)
          SELECT COUNT(id) - 1 INTO v_veri_sayisi FROM hastane_gecmis_veris
            WHERE hastane_id = v_hastane_id;

          -- Verilerin güncel olarak hesaplanması
          SET v_eski_ortalama_rey_puani = ((v_eski_ortalama_rey_puani * v_veri_sayisi) + v_yeni_rey_puani) / (v_veri_sayisi + 1);
          SET v_eski_memnuniyet = ((v_eski_memnuniyet * v_veri_sayisi) + v_yeni_memnuniyet) / (v_veri_sayisi + 1);

          IF (v_son_rey_puani = 0) THEN
            SET v_rey_puan_degisimi = NULL;
          ELSE
            SET v_rey_puan_degisimi = ((v_yeni_rey_puani - v_son_rey_puani) / GREATEST(v_son_rey_puani, 1)) * 100;
          END IF;

          -- yeni hesaplamalara göre Hastane tablosunun güncellenmesi
          UPDATE hastanes
            SET son_rey_puani = v_yeni_rey_puani, rey_puan_degisim = v_rey_puan_degisimi,
                ortalama_rey_puani = v_eski_ortalama_rey_puani, memnuniyet = v_eski_memnuniyet
          WHERE id = v_hastane_id;
        END IF;

      END LOOP;
    END;
    -- Geçici tablonun silinmesi:
    DROP TABLE sub_hastane_gecmis_veri;

    -- Tüm hastane verileri güncellendikten sonra İLÇE verilerini güncelleyecek
    -- Procedure çağrılacak!
    CALL ilce_bazinda_hesaplama();
  END;