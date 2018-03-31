class CreateReyKayitlaris < ActiveRecord::Migration[5.1]
  def change
    create_table :rey_kayitlaris do |t|
      t.references :muayene, foreign_key: true, null: false
      t.integer :soru_1
      t.integer :soru_2
      t.integer :soru_3
      t.integer :soru_4
      t.integer :soru_5
      t.text :yorum
      # t.integer :toplam_puan

      t.timestamps
    end
    # <toplam_puan> is added AS computed column.!
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE rey_kayitlaris
          ADD COLUMN toplam_puan DECIMAL(6,3) AS
          (soru_1 + soru_2 + soru_3 + soru_4 + soru_5)
          STORED;
        SQL
      end
    end
    ##
  end
end
