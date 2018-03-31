class Ilce < ApplicationRecord
  belongs_to :il
  has_many :hastanes

  def self.ilce_id_isim_il_id
    Ilce.select(:id, :isim, :il_id).pluck(:id, :isim, :il_id)
  end

  def self.ilce_istatistik
    Ilce.joins(:il).select('ils.isim', 'ilces.isim', 'ilces.son_rey_puani',
    'ilces.rey_puan_degisim', 'ilces.ortalama_rey_puani', 'ilces.memnuniyet')
        .pluck('ils.isim', 'ilces.isim', 'ilces.son_rey_puani',
    'ilces.rey_puan_degisim', 'ilces.ortalama_rey_puani', 'ilces.memnuniyet')
        .sort_alphabetical_by(&:first)
  end
end
