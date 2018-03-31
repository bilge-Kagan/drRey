/*
Burada oluşturulacak olan EVENT, her gün saat 18.00 da
e-posta gönderilmesi gereken hastaları kontrol edecek.
 */
/*
* Dizayn edilen sistemin çalışma aralığı bu şekilde olmalı. Ancak
* test aşaması için süreler kısaltılacaktır.

CREATE EVENT skt_sms_kontrol
  ON SCHEDULE EVERY 1 DAY
  STARTS ADDDATE(CURDATE(), INTERVAL 42 HOUR) ON COMPLETION PRESERVE ENABLE
  DO
  CALL skt_sms_p();
*/
CREATE EVENT skt_sms_kontrol
  ON SCHEDULE EVERY 5 SECOND
  ON COMPLETION PRESERVE ENABLE
  DO
  CALL skt_sms_p();