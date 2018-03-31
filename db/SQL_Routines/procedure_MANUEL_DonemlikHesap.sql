/*
Uygulamanın test aşaması içerisinde hesaplamanın kullanıcı
tetiklemesiyle yapılabilmesi için bu procedure çağrılacaktır.

Normal şartlarda EVENT yardımı ile belirlenen tarihlerde
hesaplanmaktadır.
 */
CREATE PROCEDURE manuel_donemlik_hesaplama()
  BEGIN
    IF (SELECT EXISTS(SELECT id FROM anlik_veris)) THEN
      CALL anlik_veri_sifirlanma();
      CALL donemlik_basarim_kopyalama();
    ELSE
      TRUNCATE donemlik_basaris;
      TRUNCATE rey_skts;
      TRUNCATE mail_lists;
      CALL yeni_donem();
    END IF;

  END;