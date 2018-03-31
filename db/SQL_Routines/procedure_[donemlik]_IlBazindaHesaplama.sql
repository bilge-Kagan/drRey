/*
İlçe verileri güncellendikten sonra bu procedure çağrılacaktır.
Burada da Hastane ve İlçe verilerinin hesaplanmasında kullanılan
yönteme benzer bir yöntem kullanılacaktır.
 */
CREATE PROCEDURE il_bazinda_hesaplama()
  BEGIN
    -- İle ait son rey puani:
    DECLARE v_il_son_rey_puani DECIMAL(7,4) DEFAULT (0);

    -- İlçe tablosundan çekilecke veriler:
    DECLARE v_il_id INTEGER;
    DECLARE v_son_rey_puani DECIMAL(7,4) DEFAULT 0;
    DECLARE v_ortalama_rey_puani DECIMAL(7,4) DEFAULT 0;
    DECLARE v_ortalama_memnuniyet DECIMAL(7,4) DEFAULT 0;

    -- Hesaplanacak değişken:
    DECLARE v_rey_puan_degisimi DECIMAL(7,4);

    -- Handler değişkeni:
    DECLARE exit_loop_5 BOOLEAN;

    -- Oluşturuluacak geçiçi tablonun tanımı:
    CREATE TABLE sub_ilce(
      c_il_id INTEGER,
      c_son_rey_puani DECIMAL(7,4),
      c_ortalama_rey DECIMAL(7,4),
      c_memnuniyet DECIMAL(7,4)
    );

    -- Geçici tabloya verilerin eklenmesi:
    INSERT INTO sub_ilce(c_il_id, c_son_rey_puani, c_ortalama_rey, c_memnuniyet)
      SELECT il_id, SUM(son_rey_puani) / COUNT(il_id), SUM(ortalama_rey_puani) / COUNT(il_id), SUM(memnuniyet) / COUNT(il_id)
        FROM ilces
    GROUP BY il_id;

    -- Nested BEGIN.. END
    BEGIN
      -- Cursor Oluşturulması:
      DECLARE sub_ilce_cursor CURSOR FOR
        SELECT c_il_id, c_son_rey_puani, c_ortalama_rey, c_memnuniyet
      FROM sub_ilce;

      -- Handler:
      DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop_5 = TRUE ;

      -- LOOP:
      OPEN sub_ilce_cursor;
      ilce_loop: LOOP
        FETCH sub_ilce_cursor
          INTO v_il_id, v_son_rey_puani, v_ortalama_rey_puani, v_ortalama_memnuniyet;

        IF (exit_loop_5 = TRUE) THEN
          CLOSE sub_ilce_cursor;
          LEAVE ilce_loop;
        ELSE
          -- İl'e ait son rey puaninin çekilmesi:
          -- Bu veri rey puani değişimin hesaplanmasında kullanılacaktır.
          SELECT son_rey_puani INTO v_il_son_rey_puani
            FROM ils
          WHERE id = v_il_id;

          -- Değişimin hesaplanması
          IF (v_il_son_rey_puani = 0) THEN
            SET v_rey_puan_degisimi = NULL;
          ELSE
            SET v_rey_puan_degisimi = ((v_son_rey_puani - v_il_son_rey_puani) / GREATEST(v_il_son_rey_puani,1)) * 100;
          END IF;

          -- İL tablosunun güncellenmesi:
          UPDATE ils
            SET son_rey_puani = v_son_rey_puani, rey_puan_degisim = v_rey_puan_degisimi,
                ortalama_rey_puani = v_ortalama_rey_puani, memnuniyet = v_ortalama_memnuniyet
          WHERE id = v_il_id;
        END IF;

      END LOOP;
    END;
    -- Geçici tablonun silinmesi:
    DROP TABLE sub_ilce;

    -- İL tablosundaki veriler de güncellendiğine göre şimdi ülke bazındaki hesaplama
    -- yapılacaktır. Ancak ülke bazındaki veriler İL tablosu yardımı ile HESAPLANMAYACAK.
    -- Onun yerine daha önce de kullandığımız hastane geçmiş verisi kullanılacak.
    -- Ayrıca ülke verileri DONEM-DONEM kaydedilecek. İL, İLÇE ve HASTANE verileri
    -- gibi her dönem güncellenmeyecek.
    -- Bu hesaplamaya dair procedure burada çağrılacaktır.
    CALL ulke_geneli_hesaplama();
  END;