module RegistrationHelper
  # İl Select_box
  def il_select(il_array)
    select_array = []
    il_array.each do |elem|
      value = [elem[0].to_i]
      select_array << [elem[1].to_s, value.to_s]
    end
    select_array
  end

  # İlçe Select box
  def ilce_select(ilce_array)
    select_array = []
    ilce_array.each do |elem|
      value = [elem[0].to_i, elem[2].to_i]
      select_array << [elem[1].to_s, value.to_s]
    end
    select_array
  end

  # Hastane Select box
  def hastane_select(hastane_array)
    select_array = []
    hastane_array.each do |elem|
      value = [elem[0].to_i, elem[2].to_i, elem[3].to_i]
      select_array << [elem[1].to_s, value.to_s]
    end
    select_array
  end

  # Servis Select box
  def servis_select(servis_array)
    select_array = []
    servis_array.each do |elem|
      value = [elem[0].to_i]
      select_array << [elem[1].to_s, value.to_s]
    end
    select_array
  end

  # Doktor Select box
  def doktor_select(doktor_array)
    select_array = []
    doktor_array.each do |elem|
      value = [elem[0].to_i, elem[3].to_i, elem[4].to_i, elem[5].to_i]
      select_array << [elem[1].to_s + ' ' + elem[2].to_s, value.to_s]
    end
    select_array
  end
end
