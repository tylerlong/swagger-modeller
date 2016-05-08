class RequestModel < ActiveRecord::Base
  validates :verb_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :verb_id }
  validates :properties_text, presence: true
  belongs_to :verb
  has_many :request_model_properties, dependent: :destroy
end
