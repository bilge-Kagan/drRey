/*
Muayene tablosuna her yeni kayıt yapıldığında gereçekleşmesi gereken işlemler
şöyle ki:
  ## İlgili doktorun <AnlikVeri.hasta_sayisi> artırılacak
  ## İlgili hastanın <HastaReyIstatistik.muayene_sayisi> artırılacak
  ## Kayıt yapıldığında <Muayene.rey_kullanimi> ve <Muayene.rey_kullanim_hakki>
     verileri varsayılan değerlerde kayıt edilecek.
 */
CREATE TRIGGER yeni_kayit AFTER INSERT ON muayenes
  FOR EACH ROW
  BEGIN
    DECLARE v_doktor_id INTEGER;
    DECLARE v_hasta_id INTEGER;
    DECLARE v_baslangic INTEGER;
    DECLARE v_bitis INTEGER;
    DECLARE v_hastane_id INTEGER;
    DECLARE v_servis_id INTEGER;

    SET v_baslangic = UNIX_TIMESTAMP(NEW.created_at);
    SET v_bitis = v_baslangic + (4*24*60*60);
    -- Test aşaması için süre kısaltılabilir::!
    -- SET v_bitis = v_baslangic + (60*60);
    SET v_doktor_id = NEW.dktr_id;
    SET v_hasta_id = NEW.hast_a_id;
    -- HastaneID verisi Doktor tablosundan çekilecek. Donem içerisinde yer değiştiren
    -- doktor olursa onların konumları ancak dönem sonunda değişebilir. Bu bölümde
    -- bazı hastanelerin değer kaybı olabilir. Bunlar ihmal edilecek.

    SELECT hastane_id, hastane_servisleri_id INTO v_hastane_id, v_servis_id FROM dktrs WHERE dktrs.id = v_doktor_id;

    -- AnlikVeri tablosunda, doktora ait hasta sayısı artırıldı.
    IF (SELECT EXISTS(SELECT anlik_veris.id FROM anlik_veris WHERE anlik_veris.dktr_id = v_doktor_id)) THEN
      UPDATE anlik_veris
      SET hasta_sayisi = hasta_sayisi + 1
      WHERE anlik_veris.dktr_id = v_doktor_id;
    ELSE
      INSERT INTO anlik_veris(dktr_id, hastane_id, hastane_servisi, hasta_sayisi, rey_kullanan)
        VALUE (v_doktor_id, v_hastane_id, v_servis_id, 1, 0);
    END IF;

    -- HastaReyIstatistik tablosunda, hastaya ait muayene sayısı artırıldı.
    UPDATE hasta_rey_istatistiks
      SET toplam_muayene_sayisi = toplam_muayene_sayisi + 1
    WHERE hasta_rey_istatistiks.hast_a_id = v_hasta_id;

    -- ReySkt kaydının oluşturulması:
    INSERT rey_skts(muayene_id, baslangic, bitis)
      VALUE ((NEW.id), v_baslangic, v_bitis);
  END;