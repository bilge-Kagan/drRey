/*
Yeni hasta kaydı oluşturulduğunda HastaReyIstatistik tablosuna
hasta ile ilgili kayıt oluşturulmalı.
 */
CREATE TRIGGER hasta_rey_istatistik_reg AFTER INSERT ON hast_as
  FOR EACH ROW
  BEGIN
    INSERT INTO hasta_rey_istatistiks(hast_a_id)
      VALUE (NEW.id);
  END;