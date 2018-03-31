class RegistrationController < ApplicationController
  # Index sayfası. (Root)
  def index; end

  # DoktorKayıt Sayfası
  def dr_reg_page
    @wrapper_hash = {}

    @wrapper_hash[:il] = Il.il_id_isim
    @wrapper_hash[:ilce] = Ilce.ilce_id_isim_il_id
    @wrapper_hash[:hastane] = Hastane.hastane_id_isim_ilce_id_il_id
    @wrapper_hash[:servis] = HastaneServisleri.servis_id_isim
    @wrapper_hash[:doktor] = Dktr.id_isim_hastane_id_servis_id
  end

  def hst_reg_page
    @wrapper_hash_2 = Dktr.hasta_kayit_rel_doktor_veri
  end

  def dr_reg
    update = params[:doktor_upt]
    reg = params[:doktor_kayit]

    if reg
      @process_response = register(reg)
    elsif update
      @process_response = upt(update)
    end
  end

  def hst_reg
    reg = params[:hasta_kayit]
    @process_response_2 = h_reg(reg)
  end

  private

  # Veri kontrol ve Doktor Kayıt fonksiyonu
  def register(param)
    isim = param[:isim].to_s.capitalize.strip
    soyisim = param[:soyisim].to_s.capitalize.strip
    tc_no = param[:tc].to_s.strip
    il = param[:il].to_s != '' ? JSON.parse(param[:il].to_s)[0] : nil
    ilce = param[:ilce].to_s != '' ? JSON.parse(param[:ilce].to_s)[0] : nil
    hastane = param[:hastane].to_s != '' ? JSON.parse(param[:hastane].to_s)[0] : nil
    servis = param[:servis].to_s != '' ? JSON.parse(param[:servis].to_s)[0] : nil

    if isim.length < 2 || soyisim.length < 2
      'İsim ve Soyisim kısımlarında hata bulundu. Kontrol Ediniz..'
    elsif !(il && ilce && hastane && servis)
      'Konum eksik girildi. Kontrol ediniz..'
    elsif tc_no.length != 11 && tc_no.to_i.to_s.length != 11
      'TC numarasında hata bulundu. Kontrol ediniz..'
    elsif Hastane.hastane_konum_kontrol(hastane, il, ilce)
      'Konum bilgisinde uyuşmazlık tesbit edildi. Kontrol ediniz..'
    else
      Dktr.doktor_kayit(isim, soyisim, tc_no, hastane, servis)
      'Kayıt tamamlandı..'
    end
  end

  # Veri kontrol ve Doktor Kayıt Güncelleme Fonksiyonu
  def upt(param)
    isim_parametre = param[:isim_soyisim].to_s != '' ? JSON.parse(param[:isim_soyisim].to_s) : nil
    isim_id = isim_parametre ? isim_parametre[0] : nil
    updatable_value = isim_parametre ? isim_parametre[3] : nil
    il = param[:u_il].to_s != '' ? JSON.parse(param[:u_il].to_s)[0] : nil
    ilce = param[:u_ilce].to_s != '' ? JSON.parse(param[:u_ilce].to_s)[0] : nil
    hastane = param[:u_hastane].to_s != '' ? JSON.parse(param[:u_hastane].to_s)[0] : nil
    servis = param[:u_servis].to_s != '' ? JSON.parse(param[:u_servis].to_s)[0] : nil

    if !(isim_parametre && il && ilce && hastane && servis)
      'Konum bilgilerinde eksiklik tesbit edildi. Kontrol ediniz..'
    elsif updatable_value == 0
      'Seçilen doktora ait anlık veri kaydı bulunduğu için güncelleme \
       yapılamıyor. Sonraki dönemi beklemek zorundasınız..'
    elsif Hastane.hastane_konum_kontrol(hastane, il, ilce)
      'Konum bilgisinde uyuşmazlık tesbit edildi. Kontrol ediniz..'
    else
      Dktr.doktor_konum_guncelle(isim_id, hastane, servis)
      'Doktora ait konum güncellenmiştir..'
    end
  end

  # Hasta Registration
  def h_reg(param)
    isim = param[:isim].to_s != '' ? param[:isim].to_s.capitalize : nil
    soyisim = param[:soyisim].to_s != '' ? param[:soyisim].to_s.capitalize : nil
    tc = param[:tc].to_s != '' ? param[:tc].to_s : nil
    eposta = param[:eposta].to_s != '' ? param[:eposta].to_s : nil
    hastane = param[:hastane].to_s != '' ? JSON.parse(param[:hastane].to_s)[0] : nil
    servis = param[:servis].to_s != '' ? JSON.parse(param[:servis].to_s)[0] : nil
    doktor = param[:doktor].to_s != '' ? JSON.parse(param[:doktor].to_s)[0] : nil

    if !(isim && soyisim && tc && eposta)
      'Hasta bilgilerinde eksiklik tespit edildi. Kontrol ediniz..'
    elsif tc.length != 11 || tc.to_i.to_s.length != 11
      'TC numarasında hata tespit edildi. Kontrol ediniz..'
    elsif !(hastane && servis && doktor)
      'Hastane/Servis/Doktor verilerinde eksiklik tespit edildi. Kontrol ediniz..'
    elsif Dktr.doktor_hastane_sync(doktor, servis, hastane)
      'Hastane/Servis/Doktor verilerinde uyuşmazlık tespit edildi. Kontrol ediniz..'
    else
      HastA.muayene_kaydi(isim, soyisim, tc, eposta, doktor, hastane)
      'Muayene kaydınız oluşturuldu..'
    end
  end
end
