class Path < ActiveRecord::Base
  validates :specification_id, presence: true
  validates :uri, presence: true, uniqueness: { scope: :specification_id}
  belongs_to :specification
end
