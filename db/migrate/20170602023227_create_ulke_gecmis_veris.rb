class CreateUlkeGecmisVeris < ActiveRecord::Migration[5.1]
  def change
    create_table :ulke_gecmis_veris do |t|
      t.references :donem, foreign_key: true, null: false
      t.integer :hasta_sayisi
      t.integer :rey_kullanan
      # t.decimal :rey_kullanim_orani
      t.decimal :rey_puani, precision: 6, scale: 3
      t.decimal :memnuniyet, precision: 6, scale: 3
      t.decimal :baz_puan, precision: 6, scale: 3
    end
    # <rey_kullanim_orani> is added AS computed column.!
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE ulke_gecmis_veris
          ADD COLUMN rey_kullanim_orani DECIMAL(6,3) AS
          ((rey_kullanan / hasta_sayisi) * 100)
          STORED;
        SQL
      end
    end
    ##
  end
end
