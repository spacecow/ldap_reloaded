class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :path
      t.integer :gid
      t.string :gidname
      t.integer :account_id

      t.timestamps
    end
  end
end
