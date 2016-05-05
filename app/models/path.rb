class Path < ActiveRecord::Base
  default_scope { order("uri ASC") }

  validates :specification_id, presence: true
  validates :uri, presence: true, uniqueness: { scope: :specification_id}
  belongs_to :specification
  has_many :verbs, dependent: :destroy
end
