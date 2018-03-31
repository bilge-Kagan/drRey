class CreateDonemlikBasaris < ActiveRecord::Migration[5.1]
  def change
    create_table :donemlik_basaris do |t|
      t.references :dktr, foreign_key: true, null: false
      t.references :hastane, foreign_key: true, null: false
      t.integer :hastane_servisi, null: false, default: 0
      t.integer :hasta_sayisi, default: 0
      t.integer :rey_kullanan, default: 0
      # t.decimal :rey_kullanim_orani
      t.decimal :rey_puani, precision: 6, scale: 3, default: 0.0
      t.decimal :hasta_sayisi_degisim, precision: 6, scale: 3, null: true
      t.decimal :rey_puani_degisim, precision: 6, scale: 3, null: true
      t.decimal :memnuniyet, precision: 6, scale: 3, default: 0.0
    end
    # <rey_kullanim_orani> is added AS computed column.!
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE donemlik_basaris
          ADD COLUMN rey_kullanim_orani DECIMAL(6,3) AS
          ((rey_kullanan /  GREATEST(hasta_sayisi, 1)) * 100)
          STORED;
        SQL
      end
    end
    ##
  end
end
