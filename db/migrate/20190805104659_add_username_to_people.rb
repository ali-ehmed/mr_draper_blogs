class AddUsernameToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :username, :string
    add_index :people, :username, unique: true
  end
end
