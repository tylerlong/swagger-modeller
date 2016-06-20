class AddColumnsToVerbsTable < ActiveRecord::Migration
  def change
    add_column :verbs, :since, :string, default: ''
    add_column :verbs, :description, :string, default: ''
    add_column :verbs, :api_group, :string, default: ''
    add_column :verbs, :permissions, :string, default: ''
  end
end
