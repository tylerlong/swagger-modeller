module VerbsHelper
  def verb_status(verb)
    if verb.status == '' || verb.status == 'Normal'
      return raw '<span class="label label-success">Normal</span>'
    end
    if verb.status == 'Deprecated'
      return raw '<span class="label label-warning">Deprecated</span>'
    end
    if verb.status == 'Disabled' || verb.status == 'NoDoc'
      return raw "<span class=\"label label-danger\">#{verb.status}</span>"
    end
    return raw "<span class=\"label label-info\">#{verb.status}</span>"
  end

  def verb_visibility(verb)
    if verb.visibility.include? 'Internal'
      return raw "<span class=\"label label-warning\">#{verb.visibility}</span>"
    end
    if verb.visibility.include? 'Advanced'
      return raw "<span class=\"label label-info\">#{verb.visibility}</span>"
    end
    if verb.visibility.include? 'Basic'
      return raw "<span class=\"label label-success\">#{verb.visibility}</span>"
    end
    return raw "<span class=\"label label-info\">#{verb.visibility}</span>"
  end
end
