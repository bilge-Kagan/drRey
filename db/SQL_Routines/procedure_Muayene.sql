/*
ReyKayitlari tablosuna yeni veri eklendiğinde, yani hastalar
rey kullanıp puanlar veritabanına kaydedildiğinde; Muayene
tablosunda bulunan ilgili kaydın da güncellenmesi yapılacaktır.
 */
CREATE PROCEDURE muayene_rey_kullanimi(v_puan DECIMAL(7,4), v_muayene_id INTEGER)
  BEGIN
    DECLARE v_guncel_donem_id INTEGER;
    DECLARE v_kayit_donem_id INTEGER;
    DECLARE v_rey_kullanim_hakki INTEGER;
    DECLARE v_rey_kullanim_durumu INTEGER;
    DECLARE v_doktor_id INTEGER;
    DECLARE v_hasta_id INTEGER;

    -- İlgili verilerin Muayene tablosundan çekilmesi:
    SELECT donem_id, dktr_id, hast_a_id, rey_kullanim_hakki, rey_kullanim_durumu
      INTO v_kayit_donem_id, v_doktor_id, v_hasta_id, v_rey_kullanim_hakki, v_rey_kullanim_durumu
        FROM muayenes
          WHERE id = v_muayene_id;

    -- Guncel DonemID
    SELECT id INTO v_guncel_donem_id
      FROM donems
        ORDER BY id DESC
    LIMIT 1;

    IF (v_rey_kullanim_hakki AND NOT v_rey_kullanim_durumu) THEN

      -- Hasta Rey kullandığı için ilgili muayenede başka
      -- kullanım hakkı olmayacaktır.
      UPDATE muayenes
        SET rey_kullanim_hakki = FALSE, rey_kullanim_durumu = TRUE, updated_at = NOW()
      WHERE muayenes.id = v_muayene_id;

      -- Rey kullandığı için ilgili tablolar güncellenecek.
      -- Hasta eğer dönem aşımın durumunda değilse AnlikVeri, aksi halde
      -- DonemlikBasari tablosu güncellenecektir:
      IF (v_kayit_donem_id = v_guncel_donem_id) THEN
        CALL anlik_veri_guncelle(v_puan, v_doktor_id);
      ELSE
        CALL donemlik_basari_guncelle(v_puan, v_doktor_id);
      END IF;

      -- <HastaReyIstatistik>
      CALL hasta_istatistik_guncelle(v_puan, v_hasta_id);

      -- <Rey Kullandığı için hastaReyÖdülü:>
      UPDATE hast_as
        SET rey_odulu = rey_odulu + 1
      WHERE id = v_hasta_id;

      -- ReySkt tablosundan ilgili muayeneye ait kaydın silinmesi:
      DELETE FROM rey_skts
        WHERE muayene_id = v_muayene_id;
    END IF;
  END;