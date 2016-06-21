class Example < ActiveRecord::Base
  default_scope { order("name ASC") }
  validates :verb_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :verb_id }
  belongs_to :verb
end
