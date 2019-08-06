class AddAuthyToPeople < ActiveRecord::Migration[5.2]
  def up
    change_table :people do |t|
      t.string    :cellphone
      t.string    :country_code
      t.string    :authy_id
      t.datetime  :last_sign_in_with_authy
      t.boolean   :authy_enabled, default: false
    end

    add_index :people, :authy_id
  end

  def down
    change_table :people do |t|
      t.remove :authy_id, :last_sign_in_with_authy, :authy_enabled
    end
  end
end
