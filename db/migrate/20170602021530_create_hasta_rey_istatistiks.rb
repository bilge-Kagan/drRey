class CreateHastaReyIstatistiks < ActiveRecord::Migration[5.1]
  def change
    create_table :hasta_rey_istatistiks do |t|
      t.references :hast_a, foreign_key: true, null: false
      t.integer :toplam_muayene_sayisi, default: 0
      t.integer :toplam_rey_kullanimi, default: 0
      # t.decimal :rey_kullanim_orani
      t.decimal :rey_puani, precision: 6, scale: 3, default: 0.0
      t.decimal :memnuniyet, precision: 6, scale: 3, default: 0.0
    end
    # <rey_kullanim_orani> is added AS computed column.!
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE hasta_rey_istatistiks
          ADD COLUMN rey_kullanim_orani DECIMAL(6,3) AS
          ((toplam_rey_kullanimi / GREATEST(toplam_muayene_sayisi, 1)) * 100)
          STORED;
        SQL
      end
    end
    ##
  end
end
