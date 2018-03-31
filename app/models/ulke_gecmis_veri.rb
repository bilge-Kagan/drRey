class UlkeGecmisVeri < ApplicationRecord
  belongs_to :donem

  def self.ulke_istatistik
    UlkeGecmisVeri.joins(:donem)
        .select('ulke_gecmis_veris.hasta_sayisi', 'ulke_gecmis_veris.rey_kullanim_orani',
                'ulke_gecmis_veris.rey_puani', 'ulke_gecmis_veris.memnuniyet',
                'ulke_gecmis_veris.baz_puan', 'donems.baslangic', 'donems.bitis')
        .pluck('ulke_gecmis_veris.hasta_sayisi', 'ulke_gecmis_veris.rey_kullanim_orani',
               'ulke_gecmis_veris.rey_puani', 'ulke_gecmis_veris.memnuniyet',
               'ulke_gecmis_veris.baz_puan', 'donems.baslangic', 'donems.bitis')
        .sort_by { |item| item[6] }
  end
end
