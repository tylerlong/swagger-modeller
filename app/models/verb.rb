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

  def swagger(editions = ['Basic'])
    if not (editions.detect{ |edition| visibility.include?(edition) }.present? && (status == '' || status == 'Normal'))
      return nil
    end

    result = {
      description: name,
      responses: {
        default: {
          description: 'OK',
        },
      },
    }

    ### parameters ###

    # query parameters
    parameters = query_parameters.collect(&:swagger)

    # request body parameters
    request_body = { name: 'body', in: 'body', schema: {} }
    if request_body_properties.present? # table of properties
      request_body[:schema] = { type: 'object', properties: {} }
      request_body_properties.each do |rbp|
        request_body[:schema][:properties][rbp.name] = rbp.swagger
      end
    else
      if request_body_text.present?
        if request_body_text == 'Binary'
          request_body[:schema] = { type: 'string', format: 'binary' }
        elsif request_body_text.include? "\n" # enum of models
          request_body[:schema] = {
            type: 'object',
            enum: request_body_text.split(/[\r\n]+/).reject(&:blank?).collect do |model|
              { '$ref' => "#/definitions/#{model}" }
            end
          }
        else # model
          request_body[:schema] = { '$ref' => "#/definitions/#{request_body_text}" }
        end
      end
    end
    if request_body[:schema].present?
      parameters << request_body
    end

    if parameters.present?
      result[:parameters] = parameters
    end

    ### response ###
    if response_body_properties.blank?
      if response_body_text.present? # model name
        if response_body_text == 'Binary' # binary model
          result[:responses][:default][:schema] = { type: 'string', format: 'binary' }
        else # global model
          result[:responses][:default][:schema] = { '$ref' => "#/definitions/#{response_body_text}" }
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
