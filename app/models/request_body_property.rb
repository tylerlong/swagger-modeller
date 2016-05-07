class RequestBodyProperty < ActiveRecord::Base
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
    rbp = RequestBodyProperty.new
    rbp.name = name
    rbp.description = description
    if description.start_with?('Required.')
      rbp.required = true
    end
    if type.start_with?('Collection of ') # array
      rbp.type = 'array'
      rbp.format = type[14..-1].gsub(/\s+/, '')
      if rbp.format == 'URIs'
        rbp.format = 'string'
      end
      return rbp
    end

    if type == 'True | False' || type == "'True' | 'False'" # boolean
      rbp.type = 'boolean'
      return rbp
    end

    if type.start_with?("'") and type.end_with?("'") # enum
      rbp.type = 'string'
      rbp.format = type
      return rbp
    end

    if type == 'datetime' # datetime
      rbp.type = 'string'
      rbp.format = 'date-time'
      return rbp
    end

    if ['string', 'integer', 'number', 'boolean'].include?(type) # primitive data types
      rbp.type = type
      if rbp.type == 'integer' && rbp.name == 'conversationId'
        rbp.format = 'int64'
      end
      return rbp
    end

    rbp.type = type.gsub(/\s+/, '') # custom data types
    return rbp
  end

end
