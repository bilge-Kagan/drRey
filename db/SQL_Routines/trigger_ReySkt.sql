/*
ReySkt tablosundaki SMS değerleri her güncellendiğinde
ilgili muayeneID'ler mail_list tablosuna kaydedilecek.
Hastalara ait e-postalar da bulunarak mailList kaydı
oluşturulacak.
 */
CREATE TRIGGER mail_listesi_kayit AFTER UPDATE ON rey_skts
  FOR EACH ROW
  BEGIN
    DECLARE v_tc VARCHAR(20);
    DECLARE v_soyisim VARCHAR(255);
    DECLARE v_isim VARCHAR(255);
    DECLARE v_eposta VARCHAR(255);

    -- Hastaya ait verilerin bulunması
    SELECT hast_as.eposta, hast_as.isim, hast_as.soyisim, hast_as.tc
      INTO v_eposta, v_isim, v_soyisim, v_tc
    FROM hast_as, muayenes
      WHERE muayenes.id = NEW.muayene_id AND hast_as.id = muayenes.hast_a_id;

    -- MailList tablosuna kayıt:
    INSERT INTO mail_lists(muayene_id, hst_isim, hst_soyisim, hst_tc, e_posta)
      VALUE (NEW.muayene_id, v_isim, v_soyisim, v_tc, v_eposta);
  END;