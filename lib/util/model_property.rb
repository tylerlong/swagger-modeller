module ModelPropertyUtil

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
      return dict
    end

    if data_type == 'True | False' || data_type == "'True' | 'False'" # boolean
      dict[:data_type] = 'boolean'
      return dict
    end

    if data_type.start_with?("'") and data_type.end_with?("'") # enum
      dict[:data_type] = 'string'
      dict[:format] = data_type
      return dict
    end

    if data_type == 'datetime' # datetime
      dict[:data_type] = 'string'
      dict[:format] = 'date-time'
      return dict
    end

    if ['string', 'integer', 'number', 'boolean'].include?(data_type) # primitive data_types
      dict[:data_type] = data_type
      if dict[:data_type] == 'integer' && dict[:name] == 'conversationId'
        dict[:format] = 'int64'
      end
      return dict
    end

    dict[:data_type] = data_type.gsub(/\s+/, '') # custom data_types
    return dict
  end
  module_function :parse

  def swagger(prop)
    result = {
      type: prop.data_type,
      description: prop.description,
    }
    if prop.data_type == 'array'
      result[:items] = { type: prop.format }
      if not ['integer', 'array', 'string', 'boolean'].include? prop.format
        result[:items] = { "$ref" => '#/definitions/' + prop.format }
      end
    end
    if not ['integer', 'array', 'string', 'boolean'].include? prop.data_type # custom data_types
      result = { "$ref" => '#/definitions/' + prop.data_type }
    end
    if prop.data_type == 'string' and prop.format.start_with?("'") and prop.format.end_with?("'") #enum
      result[:enum] = prop.format.split('|').collect{ |word| word.gsub(/\A[\s']+|[\s']+\z/,'') }
    end
    if (prop.data_type == 'string' and prop.format == 'date-time') or (prop.data_type == 'integer' and prop.format.present?)
      result[:format] = prop.format
    end
    if prop.name == 'accountId' || prop.name == 'extensionId'
      result[:default] = '~'
    end
    result
  end
  module_function :swagger

end
