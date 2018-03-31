class CreateGecmisVeris < ActiveRecord::Migration[5.1]
  def change
    create_table :gecmis_veris do |t|
      t.references :dktr, foreign_key: true, null: false
      t.references :hastane, foreign_key: true, null: false
      t.references :donem, foreign_key: true, null: false
      t.integer :hastane_servisi, null: false, default: 0
      t.integer :hasta_sayisi
      t.integer :rey_kullanan
      # t.decimal :rey_kullanim_orani
      t.decimal :rey_puani, precision: 6, scale: 3, default: 0.0
      t.decimal :memnuniyet, precision: 6, scale: 3, default: 0.0
      t.integer :band
    end
    # <rey_kullanim_orani> is added AS computed column.!
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE gecmis_veris
          ADD COLUMN rey_kullanim_orani DECIMAL(6,3) AS
          ((rey_kullanan / hasta_sayisi) * 100)
          STORED;
        SQL
      end
    end
    ##
  end
end
