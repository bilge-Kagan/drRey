/*
Her gün saat 18.00 da o andan geriye dönük olarak
24 saat içerisinde muayene olan hastalara e-posta
gönderilip gönderimediğini kontrol edecek.
Gönderilmemiş hastalara ait muayene ID'ler
mail_lists tablosuna kayıt edilecek.

Rails ise her gün 19.00 da mail-list tabloyu kontrol edecek.
Tabloda veri var ise gereken yerlere e-postaları gönderecek.
E-posta gönderilen muayene ID tablodan silinecelek.
 */

/*
* Test aşaması için dizayn edilen sistemin sürelerinde
* kısaltmaya gidilecektir.

CREATE PROCEDURE skt_sms_p ()
  BEGIN
    DECLARE v_48_saat INTEGER;

    SET v_48_saat = 60*60*48;

    UPDATE rey_skts
      SET sms = TRUE
    WHERE (sms = FALSE) AND (UNIX_TIMESTAMP(NOW()) - rey_skts.baslangic) <= v_48_saat;
  END;

*/
CREATE PROCEDURE skt_sms_p ()
  BEGIN
    DECLARE v_5_sn INTEGER;

    SET v_5_sn = 5;

    UPDATE rey_skts
    SET sms = TRUE
    WHERE (sms = FALSE) AND (UNIX_TIMESTAMP(NOW()) - rey_skts.baslangic) >= v_5_sn;
  END;