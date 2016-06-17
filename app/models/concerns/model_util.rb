module ModelUtil
  extend ActiveSupport::Concern

  included do
    # statements
  end


  module ClassMethods

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

    def parse(text, modelClass)
      rows = text.split("\n").collect(&:strip).reject(&:blank?)
      items = rows.collect{ |row| modelClass.parse(row) }.reject(&:nil?).each_with_index.collect do |item, index|
          item.position = index
          item
      end
      return items
    end

  end

end
