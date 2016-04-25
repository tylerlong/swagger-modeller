module PropertiesHelper
  def link_to_type(prop)
    if ['integer', 'string', 'boolean', 'array'].include?(prop.type)
      return prop.type
    end
    return link_to prop.type, find_properties_path(type: prop.type, prefix: prop.definition.prefix)
  end

  def link_to_format(prop)
    # todo: use link_to if it is a type
    return prop.format
  end
end
