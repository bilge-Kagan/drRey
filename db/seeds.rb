# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
ActiveRecord::Base.connection.execute('SET GLOBAL event_scheduler = ON')
#
# :: Functions ::
# ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/function_eventTimer.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/function_DonemBulucu.sql'))
#
# :: Procedures ::
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_DonemlikBasari.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_AnlikVeri.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_Donem.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_HastaReyIstatistik.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_Muayene.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_ReySkt.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_ReySkt_1.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_[donemlik]_AnlikVeri_Sifirlanma.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_[donemlik]_UlkeGENELI_Hesaplama.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_[donemlik]_IlBazindaHesaplama.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_[donemlik]_IlceBazindaHesaplama.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_[donemlik]_HastaneBazindaHesaplama.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_[donemlik]_GecmisVeri.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_[donemlik]_DonemlikBasari_Kopyalanma.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/procedure_MANUEL_DonemlikHesap.sql'))
#
# :: Triggers ::
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/trigger_ReyKayitlari.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/trigger_GecmisVeri.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/trigger_Muayene_1.sql'))
# Procedure ile değiştirildi!
# ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/trigger_Muayene.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/trigger_DonemlikBasari.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/trigger_ReySkt.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/trigger_ReySkt_1.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/trigger_HastA.sql'))
#
# :: Events ::
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/event_ReySkt.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/event_ReySkt_1.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/event_[donemlik]_1.sql'))
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Routines/event_[donemlik]_2.sql'))
#
# :: DATA INITIALIZER ::
# İL, İLÇE ve HASTANE kayıtları::
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Data_Initializer/proc_il_ilce_hastane_list.sql'))
# Veritabanı kurulumu sırasında bu procedure çağrılacaktır.!
ActiveRecord::Base.connection.execute('CALL data_initializer()')
#
#
# Hastanelerde bulunabilecek klinik/bölüm/servis isimlerinin kayıtları.
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Data_Initializer/proc_hastane_servisleri.sql'))
# Veritabanı kurulumunda procedure çağrımı:
ActiveRecord::Base.connection.execute('CALL data_initializer_1()')
#
# Doktor isim, soyisimi TC ve Hastane bilgisi Kayıtları
ActiveRecord::Base.connection.execute(IO.read('db/SQL_Data_Initializer/proc_dr_kayit_list.sql'))
# Veritabanı kurulumunda procedure çağrımı:
ActiveRecord::Base.connection.execute('CALL data_initializer_2()')