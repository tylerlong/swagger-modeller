class CommonModelProperty < ActiveRecord::Base
  default_scope { order("position ASC") }

  validates :common_model_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :common_model_id }
  validates :data_type, presence: true
  validates :description, presence: true
  belongs_to :common_model

  require_dependency 'util/model_property'
  def self.parse(row)
    dict = ModelProperty.parse(row)
    dict.nil? ? nil : CommonModelProperty.new(dict)
  end

  def swagger
    ModelProperty.swagger(self)
  end
end
