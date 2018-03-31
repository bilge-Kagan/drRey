class CreateDktrs < ActiveRecord::Migration[5.1]
  def change
    create_table :dktrs do |t|
      t.string :tc
      t.string :isim
      t.string :soyisim
      t.references :hastane, foreign_key: true, null: false
      t.references :hastane_servisleri, foreign_key: true, null: false
      t.decimal :rey_puani, precision: 6, scale: 3, default: 0.0
      t.integer :band_verisi, default: 0
      t.integer :rey_katilim, default: 0
    end
    add_index :dktrs, :tc, unique: true
  end
end