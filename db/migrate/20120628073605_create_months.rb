class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.date :date

      t.timestamps
    end
  end
end
