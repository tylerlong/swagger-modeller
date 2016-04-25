module PropertiesHelper
  def link_to_type(prop)
    if ['integer', 'string', 'boolean', 'array'].include?(prop.type)
      return prop.type
    end
    return link_to prop.type, search_definitions_path(name: prop.type, prefix: prop.definition.prefix), target: '_blank'
  end

  def link_to_format(prop)
    if prop.type == 'array' && !['string'].include?(prop.format)
      return link_to prop.format, search_definitions_path(name: prop.format, prefix: prop.definition.prefix), target: '_blank'
    end
    return prop.format
  end
end
