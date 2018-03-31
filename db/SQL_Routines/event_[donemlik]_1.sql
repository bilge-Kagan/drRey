/*
Her ayın 14. gün saat 03.55 te "anlik_veri_sıfırlama" çağırılacak.
Yeni dönem de bu tarihte eklenecek.

UYARI :: EVENT ilk işlemini aşağıda belirtilen zamanda başlatacaktır. Eğer aşağıdaki zamandan
sonra başlatılırsa EVENT hata verecektir.
 */
CREATE EVENT donemlik_1
  ON SCHEDULE EVERY 1 MONTH
  STARTS '2017-08-14 03:55:00' ON COMPLETION PRESERVE ENABLE
  DO
  CALL anlik_veri_sifirlanma();