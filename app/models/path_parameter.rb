class PathParameter < ActiveRecord::Base
  default_scope { order("name ASC") }

  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id }
  validates :data_type, presence: true
  validates :description, presence: true
  belongs_to :specification

  include PropertyUtil

  def self.swagger
    result = {}
    PathParameter.all.each do |pp|
      result[pp.name] = { name: pp.name, in: 'path', required: true }.merge pp.swagger
    end
    result
  end
end
