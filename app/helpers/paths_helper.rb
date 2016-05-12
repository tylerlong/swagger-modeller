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

    return status
  end
end
