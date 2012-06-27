class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :gid
      t.string :gidname

      t.timestamps
    end
  end
end
