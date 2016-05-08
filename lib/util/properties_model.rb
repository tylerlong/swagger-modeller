module PropertiesModel

  def update_properties!(old_items, new_items)
    old_items.each do |old_item|
      if not new_items.any? { |new_item| new_item.name == old_item.name }
        old_item.destroy # delete
      end
    end
    new_items.each do |new_item|
      old_item = old_items.detect{ |old_item| old_item.name == new_item.name }
      if old_item.present?
        old_item.update_attributes(new_item.attributes.reject{ |key| ['id', 'created_at', 'updated_at'].include?(key) }) # update
      else
        new_item.save! #create
      end
    end
  end
  module_function :update_properties!

end
