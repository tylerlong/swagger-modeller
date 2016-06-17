module PropertyUtil
  extend ActiveSupport::Concern

  included do
    # statements
  end

  def swagger()
    result = {
      type: data_type,
      description: description,
    }
    if data_type == 'array'
      result[:items] = { type: format }
      if not ['integer', 'array', 'string', 'boolean'].include? format
        result[:items] = { "$ref" => '#/definitions/' + format }
      end
    end
    if not ['integer', 'array', 'string', 'boolean'].include? data_type # custom data_types
      result = { "$ref" => '#/definitions/' + data_type }
    end
    if data_type == 'string' and format.start_with?("'") and format.end_with?("'") #enum
      result[:enum] = format.split('|').collect{ |word| word.gsub(/\A[\s']+|[\s']+\z/,'') }
    end
    if (data_type == 'string' and format == 'date-time') or (data_type == 'integer' and format.present?)
      result[:format] = format
    end
    if name == 'accountId' || name == 'extensionId'
      result[:default] = '~'
    end
    result
  end

  module ClassMethods

    def parse(row)
      name, data_type, description = row.split("\t").collect(&:strip)
      if name == nil || data_type == nil || description == nil
        return nil
      end
      dict = { name: name, description: description }
      if description.start_with?('Required.') || description.start_with?('Mandatory.')
        dict[:required] = true
      end
      if data_type.start_with?('Collection of ') # array
        dict[:data_type] = 'array'
        dict[:format] = data_type[14..-1].gsub(/\s+/, '')
        if dict[:format] == 'URIs'
          dict[:format] = 'string'
        end
        return new(dict)
      end

      if data_type == 'True | False' || data_type == "'True' | 'False'" # boolean
        dict[:data_type] = 'boolean'
        return new(dict)
      end

      if data_type.start_with?("'") and data_type.end_with?("'") # enum
        dict[:data_type] = 'string'
        dict[:format] = data_type
        return new(dict)
      end

      if data_type == 'datetime' # datetime
        dict[:data_type] = 'string'
        dict[:format] = 'date-time'
        return new(dict)
      end

      if ['string', 'integer', 'number', 'boolean'].include?(data_type) # primitive data_types
        dict[:data_type] = data_type
        if dict[:data_type] == 'integer' && dict[:name] == 'conversationId'
          dict[:format] = 'int64'
        end
        return new(dict)
      end

      dict[:data_type] = data_type.gsub(/\s+/, '') # custom data_types
      return new(dict)
    end

    def swagger(prop)
      return prop.swagger
    end

  end

end
