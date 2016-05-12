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
  has_many :response_body_properties, dependent: :destroy
  has_many :response_models, dependent: :destroy

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
    PropertiesModel.update_properties!(request_body_properties, parse_request_properties)
  end

  def response_body_text=(value)
    write_attribute(:response_body_text, value)
    PropertiesModel.update_properties!(response_body_properties, parse_response_properties)
  end

  def parse_request_properties
    PropertiesModel.parse(request_body_text, RequestBodyProperty).collect do |item|
      item.verb = self
      item
    end
  end

  def parse_response_properties
    PropertiesModel.parse(response_body_text, ResponseBodyProperty).collect do |item|
      item.verb = self
      item
    end
  end

  def swagger
    if visibility.include?('Basic') && (status == '' || status == 'Normal')
      result = {
        description: name,
        responses: {
          default: {
            description: 'OK',
          },
        },
      }
      if response_body_properties.blank?
        if response_body_text.present? # model name
          if response_body_text == 'Binary' # binary model
            result[:responses][:default][:schema] = { type: 'string', format: 'binary' }
          else # global model
            result[:responses][:default][:schema] = { '$ref' => '#/definitions/' + response_body_text }
          end
        else
          # no response at all
        end
      else # list of properties
        result[:responses][:default][:schema] = { type: 'object', properties: {} }
        response_body_properties.each do |rbp|
          result[:responses][:default][:schema][:properties][rbp.name] = rbp.swagger
        end
      end
      return result
    end
  end
end
