class CreateHastaneServisleris < ActiveRecord::Migration[5.1]
  def change
    create_table :hastane_servisleris do |t|
      t.string :isim
    end
    add_index :hastane_servisleris, :isim, unique: true
  end
end
