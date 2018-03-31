/*
AnlikVeri tablosu anlık verilere tepki verebilecektir. Burada tanımlanan program(lar)
başka yerlerde çağrılabilmektedir.
 */
CREATE PROCEDURE anlik_veri_guncelle (puan DECIMAL(6,3), doktor_id INT)
  BEGIN
    DECLARE v_rey_kullanan INTEGER;
    DECLARE v_rey_puani DECIMAL(7,4);
    DECLARE v_memnuniyet DECIMAL(7,4);
    DECLARE v_baz_puan DECIMAL(6,3);
    DECLARE v_pozitif_katsayi DECIMAL(6,3);
    DECLARE v_negatif_katsayi DECIMAL(6,3);

    SELECT rey_puani, pozitif_katsayi, negatif_katsayi
      INTO v_baz_puan, v_pozitif_katsayi, v_negatif_katsayi
    FROM baz_puans
      WHERE id = 1;

    SELECT rey_kullanan, rey_puani
      INTO v_rey_kullanan, v_rey_puani
    FROM anlik_veris
      WHERE dktr_id = doktor_id;

    -- Güncel Rey puani hesaplaması
    SET v_rey_puani = ((v_rey_puani * v_rey_kullanan) + puan) / (v_rey_kullanan + 1);

    -- Memnuniyet Hesaplanması
    IF v_rey_puani <= v_baz_puan THEN
      SET v_memnuniyet = (v_rey_puani - v_baz_puan) * v_negatif_katsayi;
    ELSE
      SET v_memnuniyet = (v_rey_puani - v_baz_puan) * v_pozitif_katsayi;
    END IF;

    -- Update !!
    UPDATE anlik_veris
      SET rey_kullanan = v_rey_kullanan + 1, rey_puani = v_rey_puani, memnuniyet = v_memnuniyet
    WHERE dktr_id = doktor_id;

  END;