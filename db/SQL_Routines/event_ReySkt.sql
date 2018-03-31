/*
Burada oluşturulacak olan EVENT, reylerin son kullanım sürelerini kontrol edecek.
Muayene olduktan sonra 4 gün içerisinde rey kullanmayan hastaların
rey kullanım hakları silinecek.
 */
CREATE EVENT skt_kontrol
  ON SCHEDULE EVERY 1 MINUTE
  ON COMPLETION PRESERVE ENABLE
  DO
  CALL skt_bitis_proc();