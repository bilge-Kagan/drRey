# DrRey
***Attention:*** *Only language is supported is Turkish in this project. So remaining part of the
README is Turkish.*


### Tanım
DrRey, *kamu denetimi* kapsamında üretilmiş web tabanlı bir yazılımdır. Burada amaçlanan, kamunun
belki de en önemli ayağını oluşturan ***doktorların*** tümüyle toplum denetimi altına
alınmasıdır. Dolayısıyla toplumun tüm fertlerini kapsamaktadır.

### Çalışma Prensibi
Sistem temel olarak *anket* mantığına dayanmaktadır. Ancak basit bir anket düzeneğinden çok
daha fazlasıdır. Uygulamanın genel akış diagramı şu şekildedir:
1. Hastanın hastaneye kaydı sırasında TC kimlik numarası, isim-soyisim, iletişim bilgisi
(burada e-posta adresi), muayene tarihi, doktoru, sağlık birimi, hastane, ilçe ve il bilgileri
paralel olarak **DrRey veritabanına** kaydedilir. Bu işlem için hastanenin kayıt sistemi
üzerine kurulacak bir *API*  planlanmıştır. Böylesi bir API şu an proje dahilinde değildir.

2. Muayene kaydı yapılan hastaya özel bir şifre oluşturulur. Bu şifre bir e-posta ile
hastanın e-posta adresine gönderilir. Normalde bu gönderimin muayene gününün akşamında
yapılmalıdır. Ancak programda test amacı ile kayıt yapıldıktan hemen sonra gönderilmektedir.
Bu işlem de uygulama içerisinde simüle edilmeye çalışılmıştır.

3. Hasta muayeneden sonra kendisine gönderilen şifre ve TC kimlik numarası ile oylama
(*rey*) sayfasına giriş yapabilmektedir. Bu sayfada uzmanlar tarafından hazırlanmış beş kadar soru
yer almaktadır. Hasta bu sorulara [1,10] aralığında puan verebilmektedir. Puanlama işlemi yapıldıktan
sonra hastaya ait giriş şifresi sistemden silinir. Yapılan puanlamadan sonra veritabanında gerekli yerlere
gerekli işlemler yapılır. Veritabanı diagramı incelendiğinde bu yer ve işlemler anlaşılabilir.
Eğer hasta muayeneden sonra 4 gün içerisinde kendisindeki şifre ile rey kullanmaz ise o muayeneye ait şifre
sistemden silinmekte ve hasta ilgili muayene ile ilgili rey kullanma hakkını kaybetmektedir.

4. Her ay sonunda kayıtlı doktorlaraın her birisi için toplanan puanların ortalaması alınır. Ancak sadece belli
bir hasta sayısına ve o hastalardan da belli bir rey kullanım oranına ulaşmış doktorlar hesaplamalara katılır.
Bu ortalama en baştauzmanlar tarafından belirlenen taban puan bandında kalıyorsa doktora cezai işlem uygulanr.
Tavan bandında yer alırsa hanesine başarı olarak yazılır. Orta bantta kalması durumunda ise herhangi bir
işlem yapılmamaktadır. Buradaki ceza/ödül unsuru sistemi kullanan kurum tarfından belirlenmektedir.
(Bence maaş üzerinden olmalı.)

5. Hastalar için de ayrı bir kayıt ile *rey* kullanıp kullanmadığı, kullandıysa kaç puan verdiği, ortalama puanı,
ortalama memnuniyeti gibi veriler tutulmaktadır. Ayrıca *rey sayfası* içerisinde opsiyonel olarak hastadan
özel yorum da alınmaktadır. Tabi bu yorumlar da hasta verisi olarak tutulmakta. İleride bir itiraz
durumunda bu yorumlar her iki taraf için de delil niteliği taşımaktadır. Aklımdaki kurguda *rey* kullanan
hastalara da bir ödül düşünülmektedir. Bu durum özellikle sistemin kullanıma açılmasından sonra teşvik
için gereklidir.
 
6. Dönemlik hesaplamadan sonra eski veriler genel ortalamaya katılır ve yeni bir dönem başlar. Ortalama puanlar,
hasta sayısı, hastaların rey kullanım oranı, memnuniyet hesaplaması (en başta verilen *baz puanına* göre) gibi
kayıtlar hem doktorlar için, hem hastaneler için, hem ilçeler için, hem iller için hem de bütün ülke için
tutulmaktadır. Veritabanı incelendiğinde hangi veriler hangi birimler için tutuluyor daha net anlaşılabilir.

Çalışma prensibi en genel haliyle bu şekildedir..

### Amaçlananlar
* En başta da belirtildiği gibi ilk amaç *doktorların* halk denetimine tâbi tutulmasıdır. Böylece sağlık kalitesi
belirlenen *baz puanlar* ile artırılabilir veya belli bir seviyede tutulabilir.
* Tüm muayene bilgileri tutulduğu için hastaların herhangi bir bölgede hangi servise gittikleri dönemlik
olarak izlenebilir. Böylece bölgenin hastalık durumu, oranı, tanısı rahatlıkla takip edilebilir. Örnek vermek
gerekirse; diyelim ki bu dönem Elazığ şehrinde ciddi bir hasta artşı gözleniyor. Bu hasların da büyük bölümü
'akciğer hastalıkları' servisine gitmiş. O halde diyebiliriz ki Elazığ şehrinde hava yoluyla yayılan bir enfeksiyon
bulunmakta veya Elazığ şehrinde hava kirliliği artışı var.. Hatta bu hastaların yaş aralığı büyük oranda 25-40
arasında ise diyebiliriz ki akciğer rahatsızlıkları tetikleyen ortamlara sahip bir iş yerinde iş güvenliği
açığı bulunmaktadır. Bu projenin ilerleyen aşamalarında tutulan verileri yorumlaması için bir yapay zekâ çalışması
da yapılabilir.

Bu addeler elde edilebilecek kazanımlardan sadece ikisidir. Tutulan onca veriden başka birçok çıkarım yapılabilir.
Bu da projenin geliştirilmeye gayet açık olduğunun göstergesidir.

### Veritabanı İncelemesi
**DrRey** esasında bir *Ruby On Rails* projesinden çok bir *SQL* projesidir. Ruby On Rails tamamen kullanıcının
veri tabanına erişmesi için kullanılmıştır, yani bir nevi GUI görevi görmüştür.

Projenin kapsadığı insan sayısı bir hayli fazla olduğu için veritabanı dizaynı da aynı ölçekte efektif olmalıdır.
Aşağıda veritabanı diagramı verilmektedir.

![](https://github.com/bilge-Kagan/drRey/blob/master/ss/veritaban%C4%B1_diagram.png "Veritabanı Diagramı")

Diagram incelendiğinde tablolar arasındaki ilişkiler anlaşılabilir. Ayrıca `/db/schema.rb`
dosyasından da tablolara ait özellikler daha ayrıntılı incelenebilir.

**DrRey** sistemini güçlü yapan kilit nokta tasarımın yanında hesap yükünün Ruby on Rails yerine SQL
üzerine inşa edilmesidir. Bütün dönemlik hesaplamalar ve zamanlanmış olayların tümü *SQL*
üzerinde gerçekleştirilmektedir.

`/db/SQL_Routines/` klasöründe bulunan *.sql* dosyaları hazırlanan fonksiyonlara,
prosedürlere, tetikleyicilere ve zamanlanmış işlemlere aittir.

Bu tarz bir tasarım ile amacım tüm işlem yükünü *SQL sunucusuna* atarak, *Ruby On Rails*
üzerine sadece *client* yönetimini bırakmaktır. Çünkü projede hem işlem yükü hem de kullanıcı
sayısı hayli fazla olacaktır. İkisinin birbirini etkilemesi istenmeyen, hem de hiç istenmeyen,
bir durumdur. Diğer bir mesele de sistemin bu şekilde daha güvenli ve daha stabil olmasıdır.

İlerleyen dönemlerde verilerin sayısına bağlı olarak sistemin çalışma hızı en az şekilde
etkilenmelidir. Geniş veritabanına sahip web tabanlı bir projede sanıyorum sistemi en çok
yavaşlatan mesele *SQL sunucusu* ile *web sunucusu* arasındaki iletişimdir. **DrRey** tasarımında
bu da göz önünde bulundurulmuş ve iki sistem arasındaki iletişim en az düzeye indirilmeye çalışılmıştır.

Son olarak, `/db/SQL_Data_Initializer` içerisinde bulunan *.sql* scriptleri içerisinde başlangıç verileri
bulundurmaktadır. Bu verilerden sadece `proc_dr_kayit_list.sql` hayali isimler ve TC kimlik
numaraları içermekte olup gerçekle hiçbir bağlantısı yoktur. Diğer veriler ise gerçek değerlere
sahiptir; Sağlık Bakanlığı verilerinden elde edilmiştir.

### Arayüz İncelemesi
**DrRey** test amaçlı yapılmiş basit bir arayüze sahiptir. Örneğin arayüz içerisinde *Doktor Ekleme*
veya manuel *Dönemlik Hesaplama* seçenekleri bulunmakta. Ayrıca tüm istatistiksel verilere
erişim açıktır. Elbette halka açık, kullanımda olan bir **DrRey** projesinde bunlara erişimin
olmaması gerekiyor. Arayüzün amacı sadece *TEST*. Bunun bilinciyle anlatıma devam edelim..

!["Hasta Kayıt"](https://github.com/bilge-Kagan/drRey/blob/master/ss/Screenshot%20at%202017-06-23%2011-57-27.png "Hasta Kayıt")

Yukarıda *Hasta Kayıt* paneli gözükmektedir. Bu panelden test amaçlı hasta kayıdı yapılmaktadır.
Normalde bu işlem yukarıda da bahsettiğim gibi *API* yardımıyla olmalıdır. Hastamız buradan
kaydedildikten sonra sistem bekletmeden şifresini oluşturmakta ve e-posta yoluyla göndermektedir.

!["Mail Listesi"](https://github.com/bilge-Kagan/drRey/blob/master/ss/Screenshot%20at%202017-06-23%2011-59-09.png "Mail Listesi")

Gönderilen şifreye *Mail Listesi* sayfasından ulaşabiliriz. Söylediğim gibi bu da yine test
amaçlı yapılmış bir simülatördür. Aynı sayfadan hastanın TC kimlik numarası ve gönderilmiş şifre ile giriş yapılarak
*rey sayfası*na ulaşılabilir. Rey kullanıldıktan sonra burada ilgili hastaya ait şifre silinecektir ve elbette aynı şifre
ile artık giriş yapılamaz.

!["Doktor Kayıt"](https://github.com/bilge-Kagan/drRey/blob/master/ss/Screenshot%20at%202017-06-23%2011-57-44.png "Doktor Kayıt")

Bu ekran görüntüsü ise *Doktor Kayıt* sayfasını göstermektedir. Buradan yeni doktor kaydı yapılabilir. Kaydedilen doktor
ise *Hasta Kayıt* sayfasında doktor seçenekleri arasında seçilebilir.

!["Dönemlik Hesaplama"](https://github.com/bilge-Kagan/drRey/blob/master/ss/Screenshot%20at%202017-06-23%2011-58-53.png "Dönemlik Hesaplama")

Yukarıdaki *Dönemlik Hesaplama* sayfasında normalde ayda 1 defa yapılan hesaplama manuel olarak yapılabilmektedir. Tabii
ki test amaçlıdır. Ek olarak görüldüğü gibi aynı sayfada *Baz Puan* ayarlaması da yapılabilmektedir. Bu puan
alt-bant ve üst-bant seviyelerinin ayarlanmasında kulannılmaktadır. Hesaplama yapılmadan önce son ayarlanan *Baz Puan*a
göre işlem yapılacaktır. Geçmiş dönemlerin tarihleri de yine bu sayfada yazmaktadır.
 
 !["İstatistik Sayfası"](https://github.com/bilge-Kagan/drRey/blob/master/ss/Screenshot%20at%202017-06-23%2011-58-27.png "İstatistik Sayfası")

*İstatistik Sayfası* bölümünden dönemsel hesaplamalardan sonra tutulan kayıtlar, puanlar ve diğer birçok veri
izlenebilir. Buraya izlenebilcek tüm verileri eklemedim, bu biraz da ihtiyaca göre değişebilir zaten. Yine gayet
basit bir şekilde sorgulama yapılabilir.

!["Doktor Başarım"](https://github.com/bilge-Kagan/drRey/blob/master/ss/Screenshot%20at%202017-06-23%2011-58-45.png "Doktor Başarım")

*Doktor Başarım Verileri* ile doktorların her birine ait kayıtlar görülebilir. Buradaki veriler herhangi bir döneme ait
değildir. Genel olarak hepsinin ortalaması veya toplamı şeklindedir. Ayrıca doktorlara ait başarım gerçek zamanlı
olarak da izlenebilir. Yani dönemlik hesaba girmeden de o dönemdeki bazı verilere ulaşılabilir ancak arayüze bu
eklenmemiştir. 

Sonuç olarak, sistem kullanıma sokulabilecek bir arayüze sahip değildir. İnşallah burada hem arayüz geliştirmesi
yapılacak, hem *SQL* içerisinde bulunan bazı hesap hataları varsa onlar giderilecek, hem de uygun *API* geliştirilmeye
çalışılacaktır.

### Kurulum
*Ruby Versiyon*: **2.3.1** 
<br>
*MySQL Versiyon*: **5.7.18**

Görüldüğü gibi RDMS olarak *MySQL* seçilmiştir. Başka bir RDMS kullanabilmesi mümkün gözükmüyor. Çünkü yazılan **.sql**
scriptleri *MySQL* sytax'ı içermektedir.
<br>
İşletim sistemi olarak Linux tercih edilmiştir. Ancak Windows üzerinde de çalıştığı ispatlanmıştır. Anlatılan adımlar
Windows için de büyük oranda geçerlidir.
 
Uygun *Ruby* ve *MySQL* sürümleri yüklendikten sonra şu adımlar izlenir:
<br>
(Linux üzerinde *terminal*; Windows üzerinde ise *Ruby* yüklendikten sonra *Ruby Command Prompt* kullanılabilir.)
* Gereken *gem*ler *bundler* kullanılarak yüklenecektir.

        $ gem install bundler # Bundler is installed
*
        $ # change the working director to drRey/
        $ sudo bin/bundle install # Gems in drRey/Gemfile are installing
* `/config/database.yml` içerisinde bulunan
```yaml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: # YOUR MYSQL USERNAME
  password: # YOUR MYSQL PASSWORD
  socket: /var/run/mysqld/mysqld.sock
  #
  # ..
  production:
    <<: *default
    database: drRey
    username: # YOUR MYSQL USERNAME
    password: <%= ENV['DRREY_DATABASE_PASSWORD'] %> # Write password to in drRey/config/secrets.yml
```
ilgili kısımlara *MySQL* kullanıcı adınızı ve şifrenizi giriniz.
<br>
İlk kısım *development mode*, ikinci kısım ise *production mode* için gereklidir. Burada
uygulamanın *development mode* ile açılması gösterilecektir.

*
        $ # Change working directory to drRey/
        $ bin/rails db:create # Database created.
        $ bin/rails db:migrate # Database migrated.
        $ bin/rails db:seed # Predefined data and routines are installed to database.
Bu işlemlerden sonra sistemimiz çalıştırılmaya hazırdır.

*
        $ bin/rails server # System is run in development mode. To stop: CTRL+C

### Sonuç
**DrRey**, kamu üzerindeki halk denetiminin ilk adımı olması dileğiyle *sağlık* sektörünü hedef
almıştır. Bazı temel eksikleri bulunmakta. Bunlar öncelikle *arayüz* ve *API* dir. Ek olarak
*SQL* üzerinde de iyileştirmelerin yapılması lazım elbette.
İnşallah zaman buldukça ilgileceğim, felsefesi açısından değer verdiğim bir projedir.

Herhangi bir soru veya öneri için **dore.fy@gmail.com** adresini kullanabilirsiniz..        
  
