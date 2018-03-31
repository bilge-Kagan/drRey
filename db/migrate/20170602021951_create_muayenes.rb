class CreateMuayenes < ActiveRecord::Migration[5.1]
  def change
    create_table :muayenes do |t|
      t.references :donem, foreign_key: true, null: false
      t.references :hastane, foreign_key: true, null: false
      t.references :hast_a, foreign_key: true, null: false
      t.references :dktr, foreign_key: true, null: false
      t.boolean :rey_kullanim_durumu, default: false
      t.boolean :rey_kullanim_hakki, default: true

      t.timestamps
    end
  end
end
