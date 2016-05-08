# Verb is a synonym for Request

class Verb < ActiveRecord::Base
  validates :path_id, presence: true
  validates :method, presence: true
  validates :visibility, presence: true
  validates :name, presence: true, uniqueness: { scope: :path_id }
  belongs_to :path
  has_many :query_parameters, dependent: :destroy
  has_many :request_body_properties, dependent: :destroy
  has_many :request_models, dependent: :destroy

  require_dependency 'util/properties_model'

  def query_parameters_text=(value)
    write_attribute(:query_parameters_text, value)
    PropertiesModel.update_properties!(query_parameters, parse_parameters)
  end

  def parse_parameters
    PropertiesModel.parse(query_parameters_text, QueryParameter).collect do |item|
      item.verb = self
      item
    end
  end

  def request_body_text=(value)
    write_attribute(:request_body_text, value)
    PropertiesModel.update_properties!(request_body_properties, parse_properties)
  end

  def parse_properties
    PropertiesModel.parse(request_body_text, RequestBodyProperty).collect do |item|
      item.verb = self
      item
    end
  end
end
