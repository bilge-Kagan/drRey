class Muayene < ApplicationRecord
  belongs_to :donem
  belongs_to :hastane
  belongs_to :hast_a
  belongs_to :dktr
  has_one :rey_kayitlari
  has_one :rey_skt
  has_one :mail_list
end
