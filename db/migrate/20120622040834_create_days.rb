class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :date
      t.integer :user_count, :default => 0

      t.timestamps
    end
  end
end
