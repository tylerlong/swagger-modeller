class RequestBodyProperty < ActiveRecord::Base
  default_scope { order("position ASC") }

  validates :verb_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :verb_id }
  belongs_to :verb

  include PropertyUtil
end
