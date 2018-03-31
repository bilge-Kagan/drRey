class ReyController < ApplicationController
  def rey_page
    login = params[:rey_login]
    @log_result, @muayene_id = login_control(login)
  end

  def mail_page
    @mails = MailList.mails_get
  end

  def rey_use
    rey_form = params[:rey_cevap]
    muayene_id = params[:myn_id]
    @proc_response = ReyKayitlari.rey_kayit(rey_form, muayene_id)
  end

  private

  def login_control(param)
    tc = param[:tc].to_s != '' ? param[:tc].to_s : nil
    pass = param[:pass].to_s != '' ? param[:pass].to_i : nil

    if !(tc && pass)
      'TC kimlik numaranız veya şifreniz hatalı. Tekrar deneyiniz..'
    elsif tc.length != 11 || tc.to_i.to_s.length != 11
      'TC kimlik numaranız hatalı. Kontrol ediniz..'
    elsif pass.to_s.length != 6
      'Şifreniz hatalı. Kontrol ediniz..'
    elsif MailList.rey_log_kontrol(tc, pass)
      'TC numaranız bulunamadı veya şifreniz hatalı. Kontrol ediniz..'
    else
      [nil, MailList.muayene_id_get(tc, pass).to_i]
    end

  end
end
