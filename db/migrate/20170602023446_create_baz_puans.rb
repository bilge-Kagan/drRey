class CreateBazPuans < ActiveRecord::Migration[5.1]
  def change
    create_table :baz_puans do |t|
      t.decimal :rey_puani, precision: 6, scale: 3, null: false
      # t.decimal :pozitif_katsayi
      # t.decimal :negatif_katsayi

      t.timestamps
    end
    # <BazPuan.rey_pauni> varsayılan değeri: 50 !
    reversible do |dir|
      dir.up do
        execute <<-SQL
          INSERT INTO baz_puans(rey_puani, created_at, updated_at)
          VALUES(57, NOW(), NOW());
        SQL
        execute <<-SQL
          ALTER TABLE baz_puans
          ADD COLUMN pozitif_katsayi DECIMAL(6,3) AS (100 / (100 - rey_puani)) STORED,
          ADD COLUMN negatif_katsayi DECIMAL(6,3) AS (100 / (rey_puani - 0)) STORED;
        SQL
      end
    end
  end
end
