class ResponseBodyProperty < ActiveRecord::Base
  default_scope { order("position ASC") }

  validates :verb_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :verb_id }
  validates :data_type, presence: true
  validates :description, presence: true
  belongs_to :verb

  include PropertyUtil
end
