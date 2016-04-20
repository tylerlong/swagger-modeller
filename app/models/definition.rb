class Definition < ActiveRecord::Base
  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id}
  belongs_to :specification
end
