class AddPermissionsTextToSpecifications < ActiveRecord::Migration
  def change
    add_column :specifications, :permissions_text, :string, default: ''
  end
end
