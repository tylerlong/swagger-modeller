module ModelsHelper
  def link_to_type(prop)
    if ['integer', 'string', 'boolean', 'array'].include?(prop.data_type)
      return prop.data_type
    end
    return link_to_model prop.data_type
  end

  def link_to_format(prop)
    if prop.data_type == 'array' && !['string'].include?(prop.format)
      return link_to_model prop.format
    end
    return truncate prop.format, length: 32
  end

  def link_to_model(text) # single line or multiple lines
    names = text.split("\n").collect(&:strip)
    links = names.collect do |name|
      if Model.find_by_name(name)
        link_to name, search_models_path(name: name)
      else
        %(<span class="label label-danger" title="undefined model" data-toggle="tooltip">#{name}</span>)
      end
    end
    return raw links.join('<br/> &nbsp; or<br/>')
  end

  def referenced_by(model)
    specification = model.specification
    links = []
    links.concat model.referenced_by_model.collect{ |model| link_to model.name, specification_model_path(specification, model) }
    links.concat model.referenced_by_request_body.collect{ |verb| link_to "\"#{verb.name}\" Request Body", specification_path_verb_path(specification, verb.path, verb, anchor: 'request_body') }
    links.concat model.referenced_by_response_body.collect{ |verb| link_to "\"#{verb.name}\" Response Body", specification_path_verb_path(specification, verb.path, verb, anchor: 'response_body') }
    return links
  end
end
