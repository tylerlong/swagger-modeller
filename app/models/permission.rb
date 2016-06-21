class Permission < ActiveRecord::Base
  default_scope { order("name ASC") }
  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id }
  validates :description, presence: true
  belongs_to :specification
end
