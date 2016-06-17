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

  def self.swagger
    result = {}
    Model.all.each do |cm|
      result[cm.name] = {
        type: 'object',
        properties: {},
      }
      cm.model_properties.each do |cmp|
        result[cm.name][:properties][cmp.name] = cmp.swagger
      end
    end
    result
  end

  def referenced_by_model
    ModelProperty.where('data_type = ? or format = ?', name, name).collect(&:model).uniq
  end

  def referenced_by_request_body
    verbs = Verb.joins('left join request_body_properties as rbp on rbp.verb_id = verbs.id').where('rbp.id is null and verbs.request_body_text <> ?', '')
    verbs = verbs.select do |verb|
      verb.request_body_text.split("\n").collect(&:strip).include? name
    end
    verbs.concat(RequestBodyProperty.where('data_type = ? or format = ?', name, name).collect(&:verb)).uniq
  end

  def referenced_by_response_body
    verbs = Verb.joins('left join response_body_properties as rbp on rbp.verb_id = verbs.id').where('rbp.id is null and verbs.response_body_text <> ?', '')
    verbs = verbs.select do |verb|
      verb.response_body_text.split("\n").collect(&:strip).include? name
    end
    verbs.concat(ResponseBodyProperty.where('data_type = ? or format = ?', name, name).collect(&:verb)).uniq
  end

end
