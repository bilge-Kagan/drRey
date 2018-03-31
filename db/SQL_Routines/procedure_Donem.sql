/*
Burada tanımlanan "procedure", her dönem sonunda Donem tablosuna
yeni bir dönem eklemektedir. Bu procedure bir EVENT aracılığıyla
çağırılacak.
Dizayn olarak dönemler her ayın 18. günü yenilenecek. Saat ise
04:00 olarak alınacak.

!! Test edilmesi için süreler belirtildiğinden farklı girilmiştir !!
 */
CREATE PROCEDURE yeni_donem ()
  BEGIN
    DECLARE v_yeni_baslangic DATETIME;
    DECLARE v_yeni_bitis DATETIME;
    DECLARE v_eski_baslangic DATETIME;

    SELECT baslangic INTO v_eski_baslangic
    FROM donems ORDER BY id DESC LIMIT 1;

    SET v_yeni_baslangic = DATE_ADD(v_eski_baslangic, INTERVAL 1 MONTH); -- CURDATE(); -- ,DATE_ADD +  INTERVAL 4 HOUR);
    SET v_yeni_bitis = DATE_ADD(v_yeni_baslangic, INTERVAL 1 MONTH);

    INSERT INTO donems(baslangic, bitis)
      VALUE (v_yeni_baslangic, v_yeni_bitis);
  END;