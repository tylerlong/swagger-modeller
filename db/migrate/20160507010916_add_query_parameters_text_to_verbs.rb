class AddQueryParametersTextToVerbs < ActiveRecord::Migration
  def change
    add_column :verbs, :query_parameters_text, :string, default: ''
  end
end
