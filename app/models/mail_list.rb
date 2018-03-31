class MailList < ApplicationRecord
  belongs_to :muayene

  def self.mails_get
    # MailList içinde bulunan hastalara randomPass oluşturulması.
    MailList.where(random_pass: 0).find_each do |rec|
      begin
        rand_pass = rand(123_456..987_654).to_i

        if MailList.exists?(random_pass: rand_pass)
          raise 'Pass Dublicate..'
        else
          rec.update(random_pass: rand(123_456..987_654))
        end
      rescue
        redo
      end
    end

    mail_list = MailList.all.pluck(:muayene_id, :hst_isim, :hst_soyisim, :hst_tc, :e_posta, :random_pass)

    mail_list.each do |item|
      item << Muayene.find_by_id(item[0]).created_at
    end
  end

  def self.rey_log_kontrol(v_tc, v_pass)
    MailList.exists?(hst_tc: v_tc.to_s, random_pass: v_pass.to_i) ? false : true
  end

  def self.muayene_id_get(v_tc, v_pass)
    MailList.select(:muayene_id)
        .where('hst_tc = ? AND random_pass = ?', v_tc.to_s, v_pass.to_i).first.muayene_id
  end
end
