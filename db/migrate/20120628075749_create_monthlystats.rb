class CreateMonthlystats < ActiveRecord::Migration
  def change
    create_table :monthlystats do |t|
      t.integer :day_count, :default => 1
      t.date :day_of_registration
      t.integer :month_id
      t.integer :membership_id

      t.timestamps
    end
  end
end
