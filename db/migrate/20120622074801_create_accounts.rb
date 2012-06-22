class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :realname
      t.string :username
      t.integer :uid

      t.timestamps
    end
  end
end
