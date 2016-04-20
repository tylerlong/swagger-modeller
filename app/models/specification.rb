class Specification < ActiveRecord::Base
  validates :version, presence: true, uniqueness: { scope: :title}
  validates :title, presence: true
end
