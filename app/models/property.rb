class Property < ActiveRecord::Base
  validates :definition_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :definition_id }
  validates :type, presence: true
  belongs_to :definition
end
