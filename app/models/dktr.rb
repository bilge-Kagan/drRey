class Dktr < ApplicationRecord
  belongs_to :hastane
  belongs_to :hastane_servisleri
  has_one :anlik_veri
  has_one :donemlik_basari
  has_one :gecmis_veri
  has_many :muayenes

  def self.id_isim_hastane_id_servis_id
    doktor = Dktr.select(:id, :isim, :soyisim, :hastane_id, :hastane_servisleri_id)
        .pluck(:id, :isim, :soyisim, :hastane_id, :hastane_servisleri_id)

    anlik_doktor_id = AnlikVeri.select(:dktr_id).pluck(:dktr_id)

    if anlik_doktor_id.empty?
      doktor.each { |item| item << 1 }
    else
      anlik_doktor_id.each do |e_id|
        doktor.each do |dktr|
          dktr[0] == e_id ? dktr << 0 : dktr << 1
        end
      end
    end
    doktor
  end

  def self.doktor_kayit(v_isim, v_soyisim, v_tc, v_hastane_id, v_servis_id)
    unless Dktr.exists? tc: v_tc
      Dktr.create(isim: v_isim.to_s.capitalize, soyisim: v_soyisim.to_s.capitalize,
                  tc: v_tc.to_s, hastane_id: v_hastane_id.to_i, hastane_servisleri_id: v_servis_id.to_i)
    end
  end

  def self.doktor_konum_guncelle(v_id, v_hastane_id, v_servis_id)
    Dktr.where(id: v_id.to_i).update(hastane_servisleri_id: v_servis_id.to_i, hastane_id: v_hastane_id.to_i)
  end

  def self.hasta_kayit_rel_doktor_veri
    result = {}
    result[:servis] = HastaneServisleri.servis_id_isim
    result[:hastane] = []
    result[:doktor] = Dktr.id_isim_hastane_id_servis_id

    hastane = Hastane.hastane_id_isim_ilce_id_il_id

    result[:doktor].each do |item|
      hastane.each do |item2|
        if item[3] == item2[0]
          result[:hastane] << item2
          break
        end
      end
    end
    result[:hastane].uniq!
    result
  end

  def self.doktor_hastane_sync(dr_id, svs_id, hstn_id)
    doktor_hstn, doktor_svs = Dktr.select(:hastane_id, :hastane_servisleri_id)
                                  .where('dktrs.id = ?', dr_id.to_i)
                                  .pluck(:hastane_id, :hastane_servisleri_id)[0]
    svs_id == doktor_svs && hstn_id == doktor_hstn ? false : true
  end

  def self.doktor_basarim
    Dktr.joins(:hastane).joins(:hastane_servisleri)
        .select(:isim, :soyisim, :tc, :rey_puani, :band_verisi, :rey_katilim,
                'hastane_servisleris.isim', 'hastanes.kurum_kodu')
        .pluck(:isim, :soyisim, :tc, :rey_puani, :band_verisi, :rey_katilim,
               'hastane_servisleris.isim', 'hastanes.kurum_kodu')
        .sort_alphabetical_by { |item| item[1] }
  end
end
