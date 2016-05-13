class AdjustPathParameters < ActiveRecord::Migration
  def change
    add_column :specifications, :path_parameters_text, :string, default: ''
    add_column :path_parameters, :format, :string, default: ''
    add_column :path_parameters, :required, :boolean, default: true
    add_column :path_parameters, :position, :integer, default: 0
  end
end
