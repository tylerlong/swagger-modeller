class RenameCommonModels < ActiveRecord::Migration
  def change
    # todo: rename common_model_id
    rename_column :common_model_properties, :common_model_id, :model_id
    rename_table :common_models, :models
    rename_table :common_model_properties, :model_properties
  end
end
