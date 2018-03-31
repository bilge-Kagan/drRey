/*
Burada oluşturulacak olan fonksiyon parametre olarak alınan tarihi
içerisine alan dönemin ID'sini geri döndermektedir.
 */
CREATE FUNCTION donem_bul (tarih DATETIME)
  RETURNS INTEGER
  BEGIN
    DECLARE sonuc INTEGER;

    SELECT id INTO sonuc
      FROM drRey.donems
        WHERE baslangic < tarih AND bitis > tarih;

    RETURN sonuc;
  END;