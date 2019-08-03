class AddUidAndProviderToPeople < ActiveRecord::Migration[5.2]
  def change
    change_table :people, bulk: true do |t|
      t.string :provider, limit: 50, null: false, default: ''
      t.string :uid, limit: 500, null: false, default: ''
    end
  end
end
