class HastA < ApplicationRecord
  has_one :hasta_rey_istatistik
  has_many :muayenes

  def self.muayene_kaydi(v_isim, v_soyisim, v_tc, v_eposta, v_dr_id, v_hastane_id)

    unless HastA.exists? tc: v_tc
      HastA.create(isim: v_isim.to_s, soyisim: v_soyisim.to_s,
                   tc: v_tc.to_s, eposta: v_eposta.to_s)
    end

    c_hasta_id = HastA.find_by_tc(v_tc.to_s).id
    c_donem_id = Donem.last.id

    # MUAYENE KAYIDI:
    Muayene.create(donem_id: c_donem_id.to_i, hastane_id: v_hastane_id.to_i,
                   hast_a_id: c_hasta_id.to_i, dktr_id: v_dr_id.to_i)
  end
end
