/*
GecmisVeri tablosuna her veri eklendiğinde doktora ait hastaların
Rey kullanım oranına bakılır. Bu oran %50 üzerinde ise
doktor rey hesabına katılır. Buna bağlı olarak gerekli veriler
<dktr> tablosuna eklenir.
 */
CREATE TRIGGER doktor_tablosu AFTER INSERT ON gecmis_veris
  FOR EACH ROW
  BEGIN
    DECLARE v_dktr_ortalama_rey DECIMAL(7,4);
    DECLARE v_dktr_band_verisi INTEGER;
    DECLARE v_dktr_rey_katilim INTEGER;

    -- Rey Katılım şartı :
    IF NEW.rey_kullanim_orani > 50 THEN
      -- Doktora ait verilerin çekilmesi:
      SELECT rey_puani, band_verisi, rey_katilim
        INTO v_dktr_ortalama_rey, v_dktr_band_verisi, v_dktr_rey_katilim
      FROM dktrs
        WHERE dktrs.id = NEW.dktr_id;

      -- Hesaplamalar:
      SET v_dktr_ortalama_rey = ((v_dktr_ortalama_rey * v_dktr_rey_katilim) + NEW.rey_puani) / (v_dktr_rey_katilim + 1);

      IF (v_dktr_band_verisi = 0) OR (v_dktr_band_verisi * NEW.band) > 0 THEN
        SET v_dktr_band_verisi = v_dktr_band_verisi + NEW.band;
      ELSEIF NEW.band = 0 THEN
        SET v_dktr_band_verisi = 0;
      ELSE
        SET v_dktr_band_verisi = NEW.band;
      END IF;

      -- Dktr Tablosunun Güncellenmesi
      UPDATE dktrs
        SET rey_puani = v_dktr_ortalama_rey, band_verisi = v_dktr_band_verisi, rey_katilim = (v_dktr_rey_katilim + 1)
      WHERE id = NEW.dktr_id;

    END IF;
  END;