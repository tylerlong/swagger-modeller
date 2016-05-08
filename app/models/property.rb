class Property < ActiveRecord::Base
  default_scope { order("position ASC") }

  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :definition_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :definition_id }
  validates :type, presence: true
  belongs_to :definition

  require_dependency 'util'
  def self.parse(row)
    dict = ModelProperty.parse(row)
    dict.nil? ? nil : Property.new(dict)
  end
end
