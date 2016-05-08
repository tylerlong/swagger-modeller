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

  # todo: remove duplicate
  def parse_parameters
    rows = query_parameters_text.split("\n").collect(&:strip).reject{ |row| row.blank? }
    qps = rows.collect{ |row| QueryParameter.parse(row) }.reject{ |qp| qp == nil }.each_with_index.collect do |qp, index|
      qp.position = index
      qp.verb = self
      qp
    end
    return qps
  end

  def request_body_text=(value)
    write_attribute(:request_body_text, value)
    PropertiesModel.update_properties!(request_body_properties, parse_properties)
  end

  # todo: remove duplicate
  def parse_properties
    rows = request_body_text.split("\n").collect(&:strip).reject{ |row| row.blank? }
    rbps = rows.collect{ |row| RequestBodyProperty.parse(row) }.reject{ |rbp| rbp == nil }.each_with_index.collect do |rbp, index|
      rbp.position = index
      rbp.verb = self
      rbp
    end
    return rbps
  end
end
