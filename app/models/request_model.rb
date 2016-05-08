class RequestModel < ActiveRecord::Base
  validates :verb_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :verb_id }
  validates :properties_text, presence: true
  belongs_to :verb
  has_many :request_model_properties, dependent: :destroy

  require_dependency 'util/properties_model'

  def update_properties!
    PropertiesModel.update_properties!(request_model_properties, parse_properties)
  end

  def parse_properties
    PropertiesModel.parse(properties_text, RequestModelProperty).collect do |item|
      item.request_model = self
      item
    end
  end
end
