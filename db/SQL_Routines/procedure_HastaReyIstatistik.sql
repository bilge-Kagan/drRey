/*
 Hasta Rey kullanıp Muayene tablosu bu yönde güncellendiğin zaman HastaReyIstatistik
 tablosu da güncellenecektir.
 */
CREATE PROCEDURE hasta_istatistik_guncelle (puan DECIMAL(6,3), hasta_id INT)
  BEGIN
    DECLARE v_toplam_rey_kullanimi INTEGER;
    DECLARE v_rey_puani DECIMAL(7,4);
    DECLARE v_memnuniyet DECIMAL(7,4);
    DECLARE v_baz_puan DECIMAL(6,3);
    DECLARE v_pozitif_katsayi DECIMAL(6,3);
    DECLARE v_negatif_katsayi DECIMAL(6,3);

    -- BazPuan katsayıları çekilecek.
    SELECT rey_puani, pozitif_katsayi, negatif_katsayi
      INTO v_baz_puan, v_pozitif_katsayi, v_negatif_katsayi
    FROM baz_puans
      WHERE id=1;

    -- HastaReyIstatistik Tablosundan Eski Verilerin Çekilmesi:
    SELECT toplam_rey_kullanimi, rey_puani
      INTO v_toplam_rey_kullanimi, v_rey_puani
    FROM hasta_rey_istatistiks
      WHERE hast_a_id = hasta_id;

    -- Yeni Ortalama Rey Puani
    SET v_rey_puani = ((v_rey_puani * v_toplam_rey_kullanimi) + puan) / (v_toplam_rey_kullanimi + 1);

    -- Yeni Memnuniyet Hesabı
    IF v_rey_puani >= v_baz_puan THEN
      SET v_memnuniyet = (v_rey_puani - v_baz_puan) * v_pozitif_katsayi;
    ELSE
      SET v_memnuniyet = (v_rey_puani - v_baz_puan) * v_negatif_katsayi;
    END IF;

    -- Verileri güncelleme:
    UPDATE hasta_rey_istatistiks
      SET toplam_rey_kullanimi = v_toplam_rey_kullanimi + 1, rey_puani = v_rey_puani, memnuniyet = v_memnuniyet
    WHERE hast_a_id = hasta_id;

  END;