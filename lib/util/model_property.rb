module ModelProperty

  def parse(row)
    name, type, description = row.split("\t").collect(&:strip)
    if name == nil || type == nil || description == nil
      return nil
    end
    dict = { name: name, description: description }
    if description.start_with?('Required.') || description.start_with?('Mandatory.')
      dict[:required] = true
    end
    if type.start_with?('Collection of ') # array
      dict[:type] = 'array'
      dict[:format] = type[14..-1].gsub(/\s+/, '')
      if dict[:format] == 'URIs'
        dict[:format] = 'string'
      end
      return dict
    end

    if type == 'True | False' || type == "'True' | 'False'" # boolean
      dict[:type] = 'boolean'
      return dict
    end

    if type.start_with?("'") and type.end_with?("'") # enum
      dict[:type] = 'string'
      dict[:format] = type
      return dict
    end

    if type == 'datetime' # datetime
      dict[:type] = 'string'
      dict[:format] = 'date-time'
      return dict
    end

    if ['string', 'integer', 'number', 'boolean'].include?(type) # primitive data types
      dict[:type] = type
      if dict[:type] == 'integer' && dict[:name] == 'conversationId'
        dict[:format] = 'int64'
      end
      return dict
    end

    dict[:type] = type.gsub(/\s+/, '') # custom data types
    return dict
  end
  module_function :parse

  def swagger(prop)
    result = {
      type: prop.type,
      description: prop.description,
    }
    if prop.type == 'array'
      result[:items] = { type: prop.format }
      if not ['integer', 'array', 'string', 'boolean'].include? prop.format
        result[:items] = { "$ref" => '#/definitions/' + prop.format }
      end
    end
    if not ['integer', 'array', 'string', 'boolean'].include? prop.type # custom type
      result = { "$ref" => '#/definitions/' + prop.type }
    end
    if prop.type == 'string' and prop.format.start_with?("'") and prop.format.end_with?("'") #enum
      result[:enum] = prop.format.split('|').collect{ |word| word.gsub(/\A[\s']+|[\s']+\z/,'') }
    end
    if (prop.type == 'string' and prop.format == 'date-time') or (prop.type == 'integer' and prop.format.present?)
      result[:format] = prop.format
    end
    if prop.name == 'accountId' || prop.name == 'extensionId'
      result[:default] = '~'
    end
    result
  end
  module_function :swagger

end
