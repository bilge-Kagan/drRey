class StatisticController < ApplicationController
  def recalculate
    if params[:baz_puan]
      rey = params[:baz_puan][:rey_puani]
      BazPuan.baz_puan_guncelle(rey.to_f)
    end
    if params[:recalc]
      ActiveRecord::Base.connection.execute('CALL manuel_donemlik_hesaplama()')
    end
    @act_response = {}
    @act_response[:bz_puan] = BazPuan.baz_puan_degeri
    @act_response[:donem_list] = Donem.donem_list
  end

  def data_gets
    params[:stat_opt] ? option = params[:stat_opt][:category_select] : option = nil
    @response_hash = statistic_gets(option)
  end

  def dr_success
    @doktor_basarim = {}
    @doktor_basarim[:basarim_data] = Dktr.doktor_basarim
  end

  private

  def statistic_gets(param)
    res_hsh = {}

    case param
    when 'ulke_op'
      res_hsh[:ulke] = UlkeGecmisVeri.ulke_istatistik
    when 'il_op'
      res_hsh[:il] = Il.il_istatistik
    when 'ilce_op'
      res_hsh[:ilce] = Ilce.ilce_istatistik
    when 'hastane_op'
      res_hsh[:hastane] = HastaneGecmisVeri.hastane_istatistik
    when 'dr_op'
      res_hsh[:doktor] = GecmisVeri.doktor_istatistik
    when 'hasta_op'
      res_hsh[:hasta] = HastaReyIstatistik.hasta_istatistikleri
    else
      res_hsh[:error] = true
    end

    res_hsh
  end
end
