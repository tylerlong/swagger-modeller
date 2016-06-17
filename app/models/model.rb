class Model < ActiveRecord::Base
  default_scope { order("name ASC") }

  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id }
  validates :properties_text, presence: true
  belongs_to :specification
  has_many :model_properties, dependent: :destroy

  include ModelUtil

  def update_properties!
    Model.update_properties!(model_properties, parse_properties)
  end

  def parse_properties
    Model.parse(properties_text, ModelProperty).collect do |item|
      item.model = self
      item
    end
  end

  def swagger
    {
      type: 'object',
      properties: Hash[model_properties.collect{ |mp| [mp.name, mp.swagger] }]
    }
  end

  def referenced_by_model
    ModelProperty.joins(%{join models on model_properties.model_id = models.id})
      .where('models.specification_id = ? and (data_type = ? or format = ?)', specification_id, name, name)
      .collect(&:model).uniq
  end

  def referenced_by_request_body
    verbs = Verb.joins(%{left join request_body_properties as rbp on rbp.verb_id = verbs.id
                         join paths on verbs.path_id = paths.id})
        .where('paths.specification_id = ? and rbp.id is null and verbs.request_body_text <> ?', specification_id, '')
    verbs = verbs.select do |verb|
      verb.request_body_text.split("\n").collect(&:strip).include? name
    end
    verbs2 = RequestBodyProperty.joins(%{join verbs on request_body_properties.verb_id = verbs.id
                                         join paths on verbs.path_id = paths.id})
        .where('paths.specification_id = ? and (data_type = ? or format = ?)', specification_id, name, name)
        .collect(&:verb)
    verbs.concat(verbs2).uniq
  end

  def referenced_by_response_body
    verbs = Verb.joins(%{left join response_body_properties as rbp on rbp.verb_id = verbs.id
                         join paths on verbs.path_id = paths.id})
        .where('paths.specification_id = ? and rbp.id is null and verbs.response_body_text <> ?', specification_id, '')
    verbs = verbs.select do |verb|
      verb.response_body_text.split("\n").collect(&:strip).include? name
    end
    verbs2 = ResponseBodyProperty.joins(%{join verbs on response_body_properties.verb_id = verbs.id
                                          join paths on verbs.path_id = paths.id})
        .where('paths.specification_id = ? and (data_type = ? or format = ?)', specification_id, name, name)
        .collect(&:verb)
    verbs.concat(verbs2).uniq
  end

end
