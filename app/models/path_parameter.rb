class PathParameter < ActiveRecord::Base
  default_scope { order("name ASC") }

  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id }
  validates :data_type, presence: true
  validates :description, presence: true
  belongs_to :specification

  require_dependency 'util/model_property'
  def self.parse(row)
    dict = ModelProperty.parse(row)
    dict.nil? ? nil : PathParameter.new(dict)
  end

  def self.swagger
    result = {}
    PathParameter.all.each do |pp|
      result[pp.name] = { name: pp.name, in: 'path', required: true }.merge ModelProperty.swagger(pp)
    end
    result
  end
end
