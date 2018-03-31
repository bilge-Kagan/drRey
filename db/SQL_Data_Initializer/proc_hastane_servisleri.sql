/*
Hastanelerde bulunabilecek klinik isimleri ilgili tabloya kaydedilecektir.
Bu tabloya sonradan ekleme yapılabilir, ancak kayıt silinemez.
 */
/*
  UYARI::
Burada bulunan kilnik isimleri sadece TEST amaçlı yüklenmiştir.
Bu sebeple geniş kapsamlı birliste değildir.
 */
CREATE PROCEDURE data_initializer_1 ()
  BEGIN

    -- :: GEÇİCİ TABLO OLUŞTURULMASI VE VERİLERİN O TABLOYA KAYDEDİLMESİ ::

    CREATE TABLE blm (
      `c_klinik_ismi` VARCHAR(26) CHARACTER SET utf8
    );
    INSERT INTO blm VALUES ('Plastik Cerrahi Bölümü');
    INSERT INTO blm VALUES ('Nefroloji bölümü');
    INSERT INTO blm VALUES ('Fizik Tedavi bölümü');
    INSERT INTO blm VALUES ('Gastroenteroloji bölümü');
    INSERT INTO blm VALUES ('Kardiyoloji bölümü');
    INSERT INTO blm VALUES ('Göz Hastalıkları bölümü');
    INSERT INTO blm VALUES ('Psikiyatri bölümü');
    INSERT INTO blm VALUES ('Göğüs Cerrahi Hastalıkları');
    INSERT INTO blm VALUES ('Üroloji (Bevliye) bölümü');
    INSERT INTO blm VALUES ('Ortopedi Bölümü');
    INSERT INTO blm VALUES ('Dermatoloji bölümü');
    INSERT INTO blm VALUES ('Nöroloji Bölümü');
    INSERT INTO blm VALUES ('Genel Cerrahi (Hariciye)');
    INSERT INTO blm VALUES ('Enfeksiyon Bölümü');
    INSERT INTO blm VALUES ('Kalp Damar Bölümü');
    INSERT INTO blm VALUES ('Kulak burun boğaz bölümü');
    INSERT INTO blm VALUES ('Dahiliye bölümü');
    INSERT INTO blm VALUES ('Jinokoloji Bölümü');
    INSERT INTO blm VALUES ('Kadın Doğum Bölümü');

    -- :: :: ::

    -- Geçici tablodan "hastane_servisleris" tablosuna kayıt işlemi:
    INSERT IGNORE hastane_servisleris(isim)
      SELECT c_klinik_ismi
        FROM blm;

    -- Geçici tablonun silinmesi:
    DROP TABLE blm;
  END;