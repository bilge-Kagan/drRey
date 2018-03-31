/*
 Hasta Rey kullanmak istediği zaman ona gönderilen link üzerinden bunu yapabilecek.
 Linkin oluşturulması ve çözümlenmesi Ruby üzerinden yapılacak.
  Gönderilen bağlantıya girildiği zaman hastadan TC numarasını girmesi istenecektir.
  Eğer TC uyuşur ise ve Rey kullanım hakkı bulunuyor ise hasta soruların olduğu
  sayfaya yönlendirilecek.
    Sorular cevaplanıp form gönderildiği zaman, form verileri MuayeneNumarası ile birlikte
    ReyKayitlari tablosuna kayıt edilecek.

    Burada ise kayıt işlemi ile tetiklenen bir tetikleyici yapılacak. Muayene tablosu güncellenecek.
 */
CREATE TRIGGER rey_kayiti_ekleme BEFORE INSERT ON rey_kayitlaris
  FOR EACH ROW
  BEGIN
    -- Muayene_Rey_Kullanımı (Procedure) çağrılır.
    CALL muayene_rey_kullanimi(NEW.toplam_puan, NEW.muayene_id);

    -- Maillist Temizlenmesi

    -- MailList verisi, ReySkt tablosu tarafından temizlenmektedir.
    -- DELETE FROM mail_lists
      -- WHERE mail_lists.muayene_id = NEW.muayene_id  ;
  END;