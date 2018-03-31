class HastaneServisleri < ApplicationRecord
  has_many :dktrs

  def self.servis_id_isim
    HastaneServisleri.select(:id, :isim).pluck(:id, :isim)
  end
end
