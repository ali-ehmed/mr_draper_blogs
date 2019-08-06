class AddLastAuthyApprovalUuidToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :last_authy_approval_uuid, :string
  end
end
