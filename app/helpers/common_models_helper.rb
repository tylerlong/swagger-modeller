module CommonModelsHelper
  def link_to_type(prop)
    if ['integer', 'string', 'boolean', 'array'].include?(prop.type)
      return prop.type
    end
    return link_to prop.type, search_common_models_path(name: prop.type)
  end

  def link_to_format(prop)
    if prop.type == 'array' && !['string'].include?(prop.format)
      return link_to prop.format, search_common_models_path(name: prop.format)
    end
    return truncate prop.format, length: 32
  end

  def link_to_model(text) # single line or multiple lines
    return raw text.split("\n").collect(&:strip)
      .collect{ |name| link_to name, search_common_models_path(name: name) }
      .join('<br/>')
  end
end
