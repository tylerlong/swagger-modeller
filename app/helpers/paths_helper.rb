module PathsHelper
  def path_status(path)
    green = path.verbs.detect do |verb|
      verb.visibility.include?('Basic') && (verb.status == '' || verb.status == 'Normal')
    end
    if green.present?
      return raw "<span class=\"label label-success\">Basic</span>"
    end

    yellow = path.verbs.detect do |verb|
      verb.visibility.include?('Advanced') && (verb.status == '' || verb.status == 'Normal')
    end
    if yellow.present?
      return raw "<span class=\"label label-warning\">Advanced</span>"
    end

    internal = path.verbs.detect do |verb|
      verb.visibility.include?('Internal')
    end
    if internal.present?
      return raw "<span class=\"label label-danger\">Internal</span>"
    end

    if path.verbs.blank?
      return raw "<span class=\"label label-info\">Empty</span>"
    else
      return raw "<span class=\"label label-danger\">#{path.verbs.first.status}</span>"
    end
  end
end
