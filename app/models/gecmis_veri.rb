class GecmisVeri < ApplicationRecord
  belongs_to :dktr
  belongs_to :hastane
  belongs_to :donem

  def self.doktor_istatistik
    GecmisVeri.joins(:donem).joins(:dktr)
        .select('dktrs.isim', 'dktrs.soyisim', 'dktrs.tc', 'donems.baslangic', 'donems.bitis',
                'gecmis_veris.hasta_sayisi', 'gecmis_veris.rey_kullanim_orani',
                'gecmis_veris.rey_puani', 'gecmis_veris.memnuniyet', 'gecmis_veris.band')
        .pluck('dktrs.isim', 'dktrs.soyisim', 'dktrs.tc', 'donems.baslangic', 'donems.bitis',
               'gecmis_veris.hasta_sayisi', 'gecmis_veris.rey_kullanim_orani',
               'gecmis_veris.rey_puani', 'gecmis_veris.memnuniyet', 'gecmis_veris.band')
        .sort_alphabetical(&:first)
  end
end
