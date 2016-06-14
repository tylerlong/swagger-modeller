module PathsHelper
  def path_status(path)
    status = 'danger'

    yellow = path.verbs.detect do |verb|
      verb.visibility.include?('Advanced') && (verb.status == '' || verb.status == 'Normal')
    end
    status = 'warning' if yellow.present?

    green = path.verbs.detect do |verb|
      verb.visibility.include?('Basic') && (verb.status == '' || verb.status == 'Normal')
    end
    status = 'success' if green.present?

    if status == 'success'
      return raw "<span class=\"label label-success\">Basic</span>"
    elsif status == 'warning'
      return raw "<span class=\"label label-warning\">Advanced</span>"
    else # danger
      return raw "<span class=\"label label-danger\">Internal / Deprecated / Disabed / NoDoc</span>"
    end
  end
end
