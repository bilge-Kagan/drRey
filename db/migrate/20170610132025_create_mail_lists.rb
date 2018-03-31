class CreateMailLists < ActiveRecord::Migration[5.1]
  def change
    create_table :mail_lists do |t|
      t.references :muayene, foreign_key: true
      t.string :hst_isim
      t.string :hst_soyisim
      t.string :hst_tc
      t.string :e_posta
      t.integer :random_pass, default: 0
    end
  end
end
