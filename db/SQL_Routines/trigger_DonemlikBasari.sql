/*
DonemlikBasari tablosu her güncellendiğinde, bir önceki döneme ait
rey puanona bakılarak, değişimin hesaplanması gerekmektedir. Bu hesaplama
tetikleyici aracılığıyla yapılacaktır.
 */
CREATE TRIGGER donemlik_basari_degisim BEFORE UPDATE ON donemlik_basaris
  FOR EACH ROW
  BEGIN
    DECLARE v_doktor_id INTEGER;
    DECLARE v_yeni_donem_rey_puani DECIMAL(7,4);
    DECLARE v_eski_donem_rey_puani DECIMAL(7,4) DEFAULT 0.0000;

    -- İlgili verilerin çekilmesi:
    SELECT NEW.rey_puani, NEW.dktr_id INTO v_yeni_donem_rey_puani, v_doktor_id;

    -- Eger eski kayıt var ise eski kayıt alınır. Yoksa varsayılan değer kullanılır.
    SELECT rey_puani INTO v_eski_donem_rey_puani
      FROM gecmis_veris WHERE gecmis_veris.dktr_id = v_doktor_id
    ORDER BY donem_id DESC LIMIT 1;

    -- ReyPuani Değişim oranının hesaplanması:
    SET NEW.rey_puani_degisim = (v_yeni_donem_rey_puani - v_eski_donem_rey_puani) * 100;
  END;