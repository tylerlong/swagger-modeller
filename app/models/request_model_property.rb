class RequestModelProperty < ActiveRecord::Base
  default_scope { order("position ASC") }

  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :request_model_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :request_model_id }
  validates :type, presence: true
  validates :description, presence: true
  belongs_to :request_model

  require_dependency 'util/model_property'
  def self.parse(row)
    dict = ModelProperty.parse(row)
    dict.nil? ? nil : RequestModelProperty.new(dict)
  end
end
