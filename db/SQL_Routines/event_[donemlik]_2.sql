/*
Her ayın 18. günü, saat 03:55'te dönemlik hesaplamalar yapılacaktır.
Bu event içerisinde sadece "donemlik_basarim_kopyalama" procedure'u
çağrılacaktır.
Geri kalan hesaplamalar zincirleme şeklinde gerçekleşecektir.
Bu şekilde yapılmasının amacı hesaplamaların belirli bir sıra ile
yapılmasını garanti etmektedir. Çünkü tabloların güncellenme sıraları
bu hesaplamanın akıbeti açısından hayli önem arz etmektedir.

UYARI:: Tıpkı "donelik-1" event'i gibi, bu event de aşağıda belirtilen
tarihte aktifleştirilecektir. Uygulama çalıştırılacağı zaman bu tarihlerin
çalıştırılma gününden ileride olduğunu kontrol etmek ZARURİDİR.
Aksi taktirde Event ler tanımlanır yanımlanmaz sonlandırılacaktır, hesaplamalar
yapılamayacaktır.
*/
CREATE EVENT donemlik_2
  ON SCHEDULE EVERY 1 MONTH
  STARTS '2017-08-18 03:55:00' ON COMPLETION PRESERVE ENABLE
  DO
  CALL donemlik_basarim_kopyalama();