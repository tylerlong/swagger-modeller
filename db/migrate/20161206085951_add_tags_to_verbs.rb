class AddTagsToVerbs < ActiveRecord::Migration
  def change
    add_column :verbs, :tags, :string, default: ''
  end
end
