class Property < ActiveRecord::Base
  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :definition_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :definition_id }
  validates :type, presence: true
  belongs_to :definition

  def self.parse(row)
    name, type, description = row.split("\t").collect(&:strip)
    if name == nil || type == nil || description == nil
      return nil
    end
    prop = Property.new
    prop.name = name
    prop.description = description
    if type.start_with?('Collection of ')
      prop.type = 'array'
      prop.format = type[14..-1].gsub(/\s+/, '')
      return prop
    end

    if type.start_with?("'") and type.end_with?("'")
      prop.type = 'string'
      prop.format = type
      return prop
    end

    if ['string', 'integer', 'number', 'boolean'].include?(type)
      prop.type = type
      if prop.type == 'integer' && prop.name == 'conversationId'
        prop.format = 'int64'
      end
      return prop
    end

    prop.type = type.gsub(/\s+/, '')
    return prop
  end

end
