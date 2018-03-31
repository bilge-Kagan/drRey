/*
Hastane tablosundaki veriler güncellendikten sonra, İLÇE tablosundaki
veriler de güncellenecektir.
Hesaplamada ve güncellemede Hastane tablosunda kullanılana benzer bir yöntem
uygulanacaktır.
 */
CREATE PROCEDURE ilce_bazinda_hesaplama()
  BEGIN
    -- İlçe tablosu, son rey puanı:
    DECLARE v_ilce_son_rey_puani DECIMAL(7,4) DEFAULT 0;

    -- Hastane verileri
    DECLARE v_ilce_id INTEGER;
    DECLARE v_son_rey_puani DECIMAL(7,4) DEFAULT 0;
    DECLARE v_ortalama_rey_puani DECIMAL(7,4) DEFAULT 0;
    DECLARE v_memnuniyet DECIMAL(7,4) DEFAULT 0;

    -- Hesaplama:
    DECLARE v_rey_puani_degisimi DECIMAL(7,4);

    -- Handler değişkeni:
    DECLARE exit_loop_6 BOOLEAN;

    -- Cursor için Geçici tablo Oluşturma:
    CREATE TABLE sub_hastane(
      c_ilce_id INTEGER,
      c_son_rey_puani DECIMAL(7,4),
      c_ortalama_rey_puani DECIMAL(7,4),
      c_memnuniyet DECIMAL(7,4)
    );

    -- Geçici tablo verileri:
    INSERT INTO sub_hastane(c_ilce_id, c_son_rey_puani, c_ortalama_rey_puani, c_memnuniyet)
      SELECT ilce_id, SUM(son_rey_puani) / COUNT(ilce_id), SUM(ortalama_rey_puani) / COUNT(ilce_id), SUM(memnuniyet) / COUNT(ilce_id)
        FROM hastanes
    GROUP BY ilce_id;

    -- Nested BEGIN.. END
    BEGIN
      -- Cursor:
      DECLARE sub_hastane_cursor CURSOR FOR
        SELECT c_ilce_id, c_son_rey_puani, c_ortalama_rey_puani, c_memnuniyet
          FROM sub_hastane;

      -- Handler:
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop_6 = TRUE ;

      -- LOOP:
      OPEN sub_hastane_cursor;
      hastane_loop: LOOP
        FETCH sub_hastane_cursor
          INTO v_ilce_id, v_son_rey_puani, v_ortalama_rey_puani, v_memnuniyet;

        IF (exit_loop_6 = TRUE ) THEN
          CLOSE sub_hastane_cursor;
          LEAVE hastane_loop;
        ELSE
          -- İlçeye ait eski dönemin ReyPuani:
          SELECT son_rey_puani INTO v_ilce_son_rey_puani
            FROM ilces
          WHERE id = v_ilce_id;

          -- Rey değişim oranının hesaplanması:
          IF (v_ilce_son_rey_puani = 0) THEN
            SET v_rey_puani_degisimi = NULL;
          ELSE
            SET v_rey_puani_degisimi = ((v_son_rey_puani - v_ilce_son_rey_puani) / GREATEST(v_ilce_son_rey_puani, 1)) * 100;
          END IF;

          -- verilerin güncellenemesi:
          UPDATE ilces
            SET son_rey_puani = v_son_rey_puani, rey_puan_degisim = v_rey_puani_degisimi,
                ortalama_rey_puani = v_ortalama_rey_puani, memnuniyet = v_memnuniyet
          WHERE id = v_ilce_id;
        END IF;

      END LOOP;
    END;
    -- Geçici tablonun silinmesi
    DROP TABLE sub_hastane;

    -- Bu işlemler sonucunda İLÇE verileri de güncellenmiş bulunuyor. Şimdi bu ilçe veilerinden yola çıkarak
    -- il verileri güncellenecektir.
    -- İlgili procedure çağrılacak..
    CALL il_bazinda_hesaplama();
  END;