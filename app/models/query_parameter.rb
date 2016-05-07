class QueryParameter < ActiveRecord::Base
  default_scope { order("position ASC") }

  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :verb_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :verb_id }
  validates :type, presence: true
  validates :description, presence: true
  belongs_to :verb

  # todo: remove duplicate code
  def self.parse(row)
    name, type, description = row.split("\t").collect(&:strip)
    if name == nil || type == nil || description == nil
      return nil
    end
    qp = QueryParameter.new
    qp.name = name
    qp.description = description
    if description.start_with?('Required.')
      qp.required = true
    end

    if type.start_with?("'") and type.end_with?("'") # enum
      qp.type = 'string'
      qp.format = type
      return qp
    end

    if type == 'datetime' # datetime
      qp.type = 'string'
      qp.format = 'date-time'
      return qp
    end

    if ['string', 'integer', 'boolean'].include?(type) # primitive data types
      qp.type = type
      if qp.type == 'integer' && qp.name == 'conversationId'
        qp.format = 'int64'
      end
      return qp
    end

    return nil
  end

end
