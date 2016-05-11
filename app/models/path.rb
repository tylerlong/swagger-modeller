class Path < ActiveRecord::Base
  default_scope { order("uri ASC") }

  validates :specification_id, presence: true
  validates :uri, presence: true, uniqueness: { scope: :specification_id}
  belongs_to :specification
  has_many :verbs, dependent: :destroy

  def swagger
    result = {}
    verbs.each do |verb|
      verb_swagger = verb.swagger
      if verb_swagger.present?
        result[verb.method.downcase] = verb_swagger
      end
    end
    return result
  end
end
