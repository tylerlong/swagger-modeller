module VerbsHelper
  def verb_status(verb)
    if verb.status == ''
      return raw '<span class="label label-success">Normal</span>'
    end
    if verb.status == 'Deprecated'
      return raw '<span class="label label-warning">Deprecated</span>'
    end
    if verb.status == 'Disabled'
      return raw '<span class="label label-danger">Disabled</span>'
    end
    return raw "<span class=\"label label-info\">#{verb.status}</span>"
  end
end
