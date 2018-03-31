class Il < ApplicationRecord
  has_many :hastanes
  has_many :ilces

  def self.il_id_isim
    Il.select(:id, :isim).pluck(:id, :isim)
  end

  def self.il_istatistik
    Il.select(:isim, :son_rey_puani, :rey_puan_degisim, :ortalama_rey_puani, :mumnuniyet)
        .pluck(:isim, :son_rey_puani,
               :rey_puan_degisim, :memnuniyet).sort_alphabetical_by(&:first)
  end
end
