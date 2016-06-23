class Path < ActiveRecord::Base
  default_scope { order("uri ASC") }

  validates :specification_id, presence: true
  validates :uri, presence: true, uniqueness: { scope: :specification_id}
  belongs_to :specification
  has_many :verbs, dependent: :destroy

  def swagger(editions = ['Basic'])
    result = {}
    verbs.each do |verb|
      verb_swagger = verb.swagger(editions)
      if verb_swagger.present?
        result[verb.method.downcase] = verb_swagger
      end
    end
    if result.present?
      path_parameters = uri.scan(/\{([a-zA-Z]+?)\}/).flatten
      if path_parameters.present?
        result[:parameters] = path_parameters.collect{ |pp| { '$ref' => "#/parameters/#{pp}" } }
      end
    end
    return result
  end
end
