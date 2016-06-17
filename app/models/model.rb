class Model < ActiveRecord::Base
  default_scope { order("name ASC") }

  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id }
  validates :properties_text, presence: true
  belongs_to :specification
  has_many :model_properties, dependent: :destroy

  include ModelUtil

  def update_properties!
    Model.update_properties!(model_properties, parse_properties)
  end

  def parse_properties
    Model.parse(properties_text, ModelProperty).collect do |item|
      item.model = self
      item
    end
  end

  def self.swagger
    result = {}
    Model.all.each do |cm|
      result[cm.name] = {
        type: 'object',
        properties: {},
      }
      cm.model_properties.each do |cmp|
        result[cm.name][:properties][cmp.name] = cmp.swagger
      end
    end
    result
  end
end
