class PathParameter < ActiveRecord::Base
  default_scope { order("name ASC") }

  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id }
  validates :type, presence: true
  validates :description, presence: true
  belongs_to :specification

  def self.swagger
    result = {}
    PathParameter.all.each do |pp|
      result[pp.name] = {
        name: pp.name,
        in: 'path',
        description: pp.description,
        type: pp.type,
        required: true,
      }
    end
    result
  end
end
