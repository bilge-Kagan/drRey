class HastaReyIstatistik < ApplicationRecord
  belongs_to :hast_a

  def self.hasta_istatistikleri
    HastaReyIstatistik.joins(:hast_a)
        .select('hast_as.isim', 'hast_as.soyisim', 'hast_as.tc',
                'hasta_rey_istatistiks.toplam_muayene_sayisi',
                'hasta_rey_istatistiks.rey_kullanim_orani',
                'hasta_rey_istatistiks.rey_puani',
                'hasta_rey_istatistiks.memnuniyet')
        .pluck('hast_as.isim', 'hast_as.soyisim', 'hast_as.tc',
               'hasta_rey_istatistiks.toplam_muayene_sayisi',
               'hasta_rey_istatistiks.rey_kullanim_orani',
               'hasta_rey_istatistiks.rey_puani',
               'hasta_rey_istatistiks.memnuniyet').sort_alphabetical_by(&:first)
  end
end
