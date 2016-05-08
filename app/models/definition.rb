class Definition < ActiveRecord::Base
  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id}
  belongs_to :specification
  has_many :properties, dependent: :destroy

  require_dependency 'util/properties_model'

  def update_properties!
    PropertiesModel.update_properties!(properties, parse_properties)
  end

  def parse_properties
    PropertiesModel.parse(properties_text, Property).collect do |item|
      item.definition = self
      item
    end
  end

  def prefix
    name.split('.')[0]
  end

  def self.search(name, prefix)
    if ['string', 'integer', 'boolean', 'array'].include?(name)
      return nil
    end
    defi = Definition.find_by_name(name) # name includes prefix already
    if defi.present?
      return defi
    end
    defi = Definition.find_by_name(prefix + '.' + name) # name in specified prefix
    if defi.present?
      return defi
    end
    defi = Definition.find_by_name('Common.' + name) # name with common prefix
    if defi.present?
      return defi
    end
    return nil
  end
end
