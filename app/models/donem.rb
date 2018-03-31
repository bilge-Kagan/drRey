class Donem < ApplicationRecord
  has_many :gecmis_veris
  has_many :muayenes
  has_many :hastane_gecmis_veris
  has_one :ulke_gecmis_veri

  def self.donem_list
    Donem.select(:id, :baslangic, :bitis).pluck(:id, :baslangic, :bitis)
  end
end
