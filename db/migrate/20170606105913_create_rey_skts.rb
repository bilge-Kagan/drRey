class CreateReySkts < ActiveRecord::Migration[5.1]
  def change
    create_table :rey_skts do |t|
      t.references :muayene, foreign_key: true, null: false
      t.integer :baslangic
      t.integer :bitis
      t.boolean :sms, default: false
    end
  end
end
