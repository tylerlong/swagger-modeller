class ModelProperty < ActiveRecord::Base
  default_scope { order("position ASC") }

  validates :model_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :model_id }
  validates :data_type, presence: true
  validates :description, presence: true
  belongs_to :model

  include PropertyUtil
end
