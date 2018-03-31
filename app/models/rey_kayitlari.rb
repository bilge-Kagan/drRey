class ReyKayitlari < ApplicationRecord
  belongs_to :muayene

  COEFFICIENTS = Array.new(5, 2)
  def self.rey_kayit(param, muayene_id)
    s1 = param[:soru_1].to_s != '' ? param[:soru_1].to_i : nil
    s2 = param[:soru_2].to_s != '' ? param[:soru_2].to_i : nil
    s3 = param[:soru_3].to_s != '' ? param[:soru_3].to_i : nil
    s4 = param[:soru_4].to_s != '' ? param[:soru_4].to_i : nil
    s5 = param[:soru_5].to_s != '' ? param[:soru_5].to_i : nil
    text = param[:yorum].to_s
    myn_id = muayene_id.to_i

    if !(s1 && s2 && s3 && s4 && s5)
      'Soruları tam olarak cevaplamanız gerekmektedir. Lütfen kontrol ediniz..'
    else
      answ = [s1, s2, s3, s4, s5]
      answ.each_with_index { |item, index| answ[index] = item * COEFFICIENTS[index] }

      ReyKayitlari.create(soru_1: answ[0], soru_2: answ[1],
                          soru_3: answ[2], soru_4: answ[3],
                          soru_5: answ[4], yorum: text, muayene_id: myn_id)

      'Rey kaydınız tamamlandı. İlginiz için teşekkür ederiz..'
    end
  end
end
