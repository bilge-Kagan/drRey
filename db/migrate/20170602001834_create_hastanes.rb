class CreateHastanes < ActiveRecord::Migration[5.1]
  def change
    create_table :hastanes do |t|
      t.string :isim
      t.string :kurum_kodu
      t.references :il, foreign_key: true, null: false
      t.references :ilce, foreign_key: true, null: false
      t.decimal :son_rey_puani, precision: 6, scale: 3, default: 0.0
      t.decimal :rey_puan_degisim, precision: 6, scale: 3
      t.decimal :ortalama_rey_puani, precision: 6, scale: 3, default: 0.0
      t.decimal :memnuniyet, precision: 6, scale: 3, default: 0.0
    end
    add_index :hastanes, %i[isim kurum_kodu], unique: true
  end
end
