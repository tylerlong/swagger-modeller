class Property < ActiveRecord::Base
  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :definition_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :definition_id }
  validates :type, presence: true
  belongs_to :definition
end
