/*
AnlıkVeri tablosunun DonemlikBasari tablosuna kopyalanmasından ve sıfırlanmasından
sonra Rey kullanım hakkı bulunan yani muayene zamanlari dönüm noktası bandına denk
gelen hastaların verileri AnlıkVeri tablosu yerine DonemlikBasari tablosuna
kaydedilecektir.
Bu vesile ile ne bu durumdaki hastaların kullandıkları reyler mağdur edilecek,
ne de doktorların başarımının ölçümünde bir aksalık, bir noksanlık yaşanacaktır.

Ayrıca AnlıkVeri tablosu diğer tablolardan yaklaşık 4 gün önce sıfırlanacaktır.
DönemlikBasari tablosu da yine AnlikVeri ile birlikte güncellenecektir.
Lakin diğer tabloların güncellenmesi için bir önceki dönemde muayene olan ve hala
Rey kullanma hakkı bulunan hastaların Rey haklarının bitmesi beklenecektir.

Her hastanın Rey kullanmak için 4 gün süresi olacaktır.
 */
CREATE PROCEDURE donemlik_basari_guncelle (puan DECIMAL(6,3), doktor_id INTEGER)
  BEGIN
    DECLARE v_rey_kullanan INTEGER;
    DECLARE v_rey_puani DECIMAL(7,4);
    DECLARE v_memnuniyet DECIMAL(7,4);
    DECLARE v_baz_puan DECIMAL(6,3);
    DECLARE v_pozitif_katsayi DECIMAL(6,3);
    DECLARE v_negatif_katsayi DECIMAL(6,3);

    -- BazPuan değerleri çekilecek:
    SELECT rey_puani, pozitif_katsayi, negatif_katsayi
      INTO v_baz_puan, v_pozitif_katsayi, v_negatif_katsayi
    FROM baz_puans
      WHERE id = 1;

    -- Ilgili değerlerin tablodan çekilmesi:
    SELECT rey_kullanan, rey_puani, memnuniyet
      INTO v_rey_kullanan, v_rey_puani, v_memnuniyet
    FROM donemlik_basaris
      WHERE dktr_id = doktor_id;

    -- rey_puaninin güncellenmesi
    SET v_rey_puani = ((v_rey_puani * v_rey_kullanan) + puan) / (v_rey_kullanan + 1);

    -- Memnuniyet güncellemesi
    IF v_rey_puani >= v_baz_puan THEN
      SET v_memnuniyet = (v_rey_puani - v_baz_puan) * v_pozitif_katsayi;
    ELSE
      SET v_memnuniyet = (v_rey_puani - v_baz_puan) * v_negatif_katsayi;
    END IF;

    -- Tablonun güncellenmesi
    UPDATE donemlik_basaris
      SET rey_kullanan = v_rey_kullanan + 1, rey_puani = v_rey_puani, memnuniyet = v_memnuniyet
    WHERE dktr_id = doktor_id;

  END;