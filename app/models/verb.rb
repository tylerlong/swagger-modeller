# Verb is a synonym for Request

class Verb < ActiveRecord::Base
  validates :path_id, presence: true
  validates :method, presence: true
  validates :visibility, presence: true
  validates :name, presence: true, uniqueness: { scope: :path_id }
  belongs_to :path
end
