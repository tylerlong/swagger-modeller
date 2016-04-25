module GeneratorsHelper

  def csharp_type(prop)
    if prop.type == 'array'
      return prop.format + '[]'
    end
    if prop.type == 'integer'
      if prop.format == 'int64'
        return 'long'
      end
      return 'int'
    end
    return prop.type
  end

end
