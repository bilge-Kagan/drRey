module StatisticHelper
  def il_multiple(data)
    result = []
    data.each do |item|
      result << [item[0], item[0]]
    end
    result
  end

  def ilce_multiple(data)
    result = []
    data.each_with_index do |item, index|
      result << [item[1].to_s + ', ' + item[0].to_s, index + 1]
    end
    result
  end

  def hastane_multiple(data)
    result = []
    data.each do |item|
      result << [item[1], item[0]]
    end
    result
  end

  def doktor_multiple(data)
    result = []
    data.each do |item|
      result << [item[2].to_s + ', ' + item[0].to_s + ' ' + item[1].to_s, item[2]]
    end
    result
  end

  def hasta_multiple(data)
    result = []
    data.each do |item|
      result << [item[2].to_s + ', ' + item[0].to_s + ' ' + item[1].to_s, item[2]]
    end
    result
  end
end
