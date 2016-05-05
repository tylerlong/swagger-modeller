class PathParameter < ActiveRecord::Base
  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id }
  validates :type, presence: true
  validates :description, presence: true
  belongs_to :specification
end
