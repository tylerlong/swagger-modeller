class CommonModelProperty < ActiveRecord::Base
  default_scope { order("position ASC") }

  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :common_model_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :common_model_id }
  validates :type, presence: true
  validates :description, presence: true
  belongs_to :common_model

  require_dependency 'util/model_property'
  def self.parse(row)
    dict = ModelProperty.parse(row)
    dict.nil? ? nil : CommonModelProperty.new(dict)
  end
end
