class RenameColumnNames < ActiveRecord::Migration
  def change
    rename_column :path_parameters, :type, :data_type
    rename_column :query_parameters, :type, :data_type
    rename_column :request_body_properties, :type, :data_type
    rename_column :response_body_properties, :type, :data_type
    rename_column :common_model_properties, :type, :data_type
  end
end
