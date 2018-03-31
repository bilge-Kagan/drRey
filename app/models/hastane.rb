class Hastane < ApplicationRecord
  belongs_to :il
  belongs_to :ilce
  has_many :dktrs
  has_many :gecmis_veris
  has_many :donemlik_basaris
  has_many :anlik_veris
  has_many :muayenes
  has_many :hastane_gecmis_veris

  def self.hastane_id_isim_ilce_id_il_id
    Hastane.select(:id, :isim, :ilce_id, :il_id).pluck(:id, :isim, :ilce_id, :il_id)
  end

  def il_ilce_hastane_json
    arr = Hastane.joins(:ilce).joins(:il).select('ils.isim, ilces.isim, hastanes.isim')
                 .where('hastanes.ilce_id = ilces.id')
                 .pluck('ils.isim, ilces.isim, hastanes.isim')

    hash_array = arr.map {|item| {:il => item[0], :ilce => item[1], :hastane => item[2]}}
    # Convert json format:
    hash_array.each(&:to_json)
  end

  def self.hastane_konum_kontrol(v_hstn_id, v_il_id, v_ilce_id)
    c_hstn_ilce_id = Hastane.find_by_id(v_hstn_id.to_i).ilce_id
    c_hstn_il_id = Hastane.find_by_id(v_hstn_id.to_i).il_id

    if (c_hstn_ilce_id == v_ilce_id.to_i) && (c_hstn_il_id == v_il_id.to_i)
      false
    else
      true
    end
  end
end
