/*
ReySkt tablosu hastaların rey kullanım sürelerini ve SMS gönderilme zamanlarını
kontrol eder. Burada tanımlanan trigger, DELETE üzerine olacaktır.
Rey kulanımı için son kullanma tarihi geçmiş kayıtların, muayene tablosu üzerindeki
rey kullanım hakkı verisi FALSE yapılacaktır.
 */
CREATE TRIGGER kullanim_hakki BEFORE DELETE ON rey_skts
  FOR EACH ROW
  BEGIN
    IF (SELECT EXISTS(SELECT rey_kullanim_hakki FROM muayenes WHERE muayenes.id = OLD.muayene_id)) THEN
      UPDATE muayenes
        SET rey_kullanim_hakki = FALSE
      WHERE id = OLD.muayene_id;
    END IF;

    IF(SELECT EXISTS(SELECT muayene_id FROM mail_lists WHERE mail_lists.muayene_id = OLD.muayene_id)) THEN
      DELETE FROM mail_lists
        WHERE mail_lists.muayene_id = OLD.muayene_id;
    END IF;
  END;
