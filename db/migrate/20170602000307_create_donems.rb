class CreateDonems < ActiveRecord::Migration[5.1]
  def change
    create_table :donems do |t|
      t.datetime :baslangic
      t.datetime :bitis
    end
    add_index :donems, %i[baslangic bitis], unique: true
    reversible do |dir|
      dir.up do
        execute <<-SQL
          INSERT INTO donems(baslangic, bitis)
            VALUE(CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 MONTH));
        SQL
      end
    end
  end
end
