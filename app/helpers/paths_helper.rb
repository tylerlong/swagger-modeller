module PathsHelper
  def path_status(path)
    status = 'warning'
    green = path.verbs.detect do |verb|
      verb.visibility.include?('Basic') && (verb.status == '' || verb.status == 'Normal')
    end
    if green.present?
      status = 'success'
    end
    status
  end
end
