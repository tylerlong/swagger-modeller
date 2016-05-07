# Verb is a synonym for Request

class Verb < ActiveRecord::Base
  validates :path_id, presence: true
  validates :method, presence: true
  validates :visibility, presence: true
  validates :name, presence: true, uniqueness: { scope: :path_id }
  belongs_to :path
  has_many :query_parameters, dependent: :destroy

  def query_parameters_text=(value)
    # todo: parse and save query_parameters
    puts 'def query_parameters_text=(value)'
    write_attribute(:query_parameters_text, value)
  end
end
