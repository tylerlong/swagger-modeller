class CommonModel < ActiveRecord::Base
  default_scope { order("name ASC") }

  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id }
  validates :properties_text, presence: true
  belongs_to :specification
  has_many :common_model_properties, dependent: :destroy

  require_dependency 'util/properties_model'

  def update_properties!
    PropertiesModel.update_properties!(common_model_properties, parse_properties)
  end

  def parse_properties
    PropertiesModel.parse(properties_text, CommonModelProperty).collect do |item|
      item.common_model = self
      item
    end
  end

  def self.swagger
    result = {}
    CommonModel.all.each do |cm|
      result[cm.name] = {
        type: 'object',
        properties: {},
      }
      cm.common_model_properties.each do |cmp|
        result[cm.name][:properties][cmp.name] = cmp.swagger
      end
    end
    result
  end
end
