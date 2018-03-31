class CreateIls < ActiveRecord::Migration[5.1]
  def change
    create_table :ils do |t|
      t.string :isim
      t.decimal :son_rey_puani, precision: 6, scale: 3, default: 0.0
      t.decimal :rey_puan_degisim, precision: 6, scale: 3
      t.decimal :ortalama_rey_puani, precision: 6, scale: 3, default: 0.0
      t.decimal :memnuniyet, precision: 6, scale: 3, default: 0.0
    end
    add_index :ils, :isim, unique: true
  end
end
