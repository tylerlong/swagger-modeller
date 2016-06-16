class RequestBodyProperty < ActiveRecord::Base
  default_scope { order("position ASC") }

  validates :verb_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :verb_id }
  validates :data_type, presence: true
  validates :description, presence: true
  belongs_to :verb

  require_dependency 'util/model_property'
  def self.parse(row)
    dict = ModelPropertyUtil.parse(row)
    dict.nil? ? nil : RequestBodyProperty.new(dict)
  end

  def swagger
    ModelPropertyUtil.swagger(self)
  end
end
