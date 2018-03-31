Rails.application.routes.draw do
  # RegistrationController
  root to: 'registration#index'

  get 'registration/dr_reg_page', to: 'registration#dr_reg_page', as: :dr_reg_p

  get 'registration/hst_reg_page', to: 'registration#hst_reg_page', as: :hst_reg_p

  post 'registration/dr_reg', to: 'registration#dr_reg', as: :dr_reg

  post 'registration/hst_reg', to: 'registration#hst_reg', as: :hst_reg
  ##
  ## ReyController
  post 'rey/rey_page', to: 'rey#rey_page', as: :rey_page

  get 'rey/mail_page', to: 'rey#mail_page', as: :mail_page

  post 'rey/rey_use/:myn_id', to: 'rey#rey_use', as: :rey_use
  ##
  ## StatisticController
  post 'statistic/recalculate', to: 'statistic#recalculate', as: :recalc

  get 'statistic/data_gets', to: 'statistic#data_gets', as: :stat_page

  get 'statistic/dr_success', to: 'statistic#dr_success', as: :dr_success
  ##
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
