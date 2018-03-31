class HastaneGecmisVeri < ApplicationRecord
  belongs_to :hastane
  belongs_to :donem

  def self.hastane_istatistik
    HastaneGecmisVeri.joins(:donem).joins(:hastane)
        .select('donems.baslangic', 'donems.bitis', 'hastanes.kurum_kodu', 'hastanes.isim',
                'hastane_gecmis_veris.hasta_sayisi', 'hastane_gecmis_veris.rey_kullanim_orani',
                'hastane_gecmis_veris.rey_puani', 'hastane_gecmis_veris.memnuniyet')
        .pluck( 'hastanes.kurum_kodu', 'hastanes.isim', 'donems.baslangic', 'donems.bitis',
               'hastane_gecmis_veris.hasta_sayisi',
               'hastane_gecmis_veris.rey_kullanim_orani', 'hastane_gecmis_veris.rey_puani',
               'hastane_gecmis_veris.memnuniyet').sort_alphabetical_by { |item| item[2] }
  end
end
