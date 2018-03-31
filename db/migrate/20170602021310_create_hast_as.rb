class CreateHastAs < ActiveRecord::Migration[5.1]
  def change
    create_table :hast_as do |t|
      t.string :tc
      t.string :isim
      t.string :soyisim
      t.string :eposta
      t.integer :rey_odulu, default: 0
    end
    add_index :hast_as, :tc, unique: true
  end
end
