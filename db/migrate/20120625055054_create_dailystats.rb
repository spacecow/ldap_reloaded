class CreateDailystats < ActiveRecord::Migration
  def change
    create_table :dailystats do |t|
      t.integer :day_id
      t.integer :member_id

      t.timestamps
    end
  end
end
