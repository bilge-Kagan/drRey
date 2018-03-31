class BazPuan < ApplicationRecord

  def self.baz_puan_guncelle(value)
    value.class == Float ? BazPuan.where('id = 1').update(rey_puani: value.to_f) : nil
  end

  def self.baz_puan_degeri
    BazPuan.find_by_id(1).rey_puani.to_f
  end
end
