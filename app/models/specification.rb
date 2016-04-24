class Specification < ActiveRecord::Base
  validates :version, presence: true, uniqueness: { scope: :title}
  validates :title, presence: true
  has_many :definitions, dependent: :destroy

  def display_name
    "#{title} #{version}"
  end
end
