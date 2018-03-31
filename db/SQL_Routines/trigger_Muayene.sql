/*
Muayene tablosundaki değerler her güncellendiğinde yapılacaklar şöyle ki:
  ## <Muayene.rey_kullanimi> ve <Muayene.rey_kullanim_hakki> verileri duruma göre
     değiştirildiğinde; yani rey kullanıldığında veya rey kullanım süresi bittiğinde,
     bu tarz güncelemeler yapıldğında ilgili tablolar güncellenecektir.
 */
CREATE TRIGGER guncelleme BEFORE UPDATE ON muayenes
  FOR EACH ROW
  BEGIN
    DECLARE v_puan DECIMAL(7,4);
    DECLARE guncel_donem_id INTEGER;
    DECLARE kayit_donem_id INTEGER;

    -- Kayıt tarihinin ID'si:
    SELECT donem_bul(OLD.created_at) INTO kayit_donem_id;

    -- Guncel Donemin ID'si Alınacak:
    SELECT id
      INTO guncel_donem_id
    FROM donems
      ORDER BY id DESC
    LIMIT 1;

    IF (NEW.rey_kullanim_durumu = TRUE) AND (OLD.rey_kullanim_hakki = TRUE) THEN
      -- Hasta Rey kullandığı için o muayene için kullanım hakkını
      -- kaybediyor.
      SET NEW.rey_kullanim_hakki = FALSE;

      -- ReyKayıtları tablosundan Toplam Puanın çekilmesi:
      SELECT toplam_puan INTO v_puan FROM rey_kayitlaris WHERE muayene_id = OLD.id;

      -- Rey kullandığı için ilgili tablolar güncellenecek.
      -- <AnlikTablo.rey_kullanan> verisi:
      IF (kayit_donem_id = guncel_donem_id) THEN
        CALL anlik_veri_guncelle(v_puan, OLD.dktr_id);
      ELSE
        CALL donemlik_basari_guncelle(v_puan, OLD.dktr_id);
      END IF;

      -- <HastaReyIstatistik>
      CALL hasta_istatistik_guncelle (v_puan, OLD.hast_a_id);

      -- ReySkt tablosunda bu muayene_id ye ait veriyi sil:
      DELETE FROM rey_skts WHERE muayene_id = OLD.id;
    END IF;
  END;
