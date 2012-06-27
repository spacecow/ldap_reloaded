class CreateMembers < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.string :path
      t.integer :account_id
      t.integer :group_id

      t.timestamps
    end
  end
end
