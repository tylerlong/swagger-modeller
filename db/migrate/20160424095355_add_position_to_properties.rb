class AddPositionToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :position, :integer, default: 0
  end
end
