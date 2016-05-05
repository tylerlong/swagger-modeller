class Specification < ActiveRecord::Base
  default_scope { order("title ASC") }

  validates :version, presence: true, uniqueness: { scope: :title}
  validates :title, presence: true
  has_many :definitions, dependent: :destroy
  has_many :paths, dependent: :destroy
  has_many :path_parameters, dependent: :destroy

  def display_name
    "#{title} #{version}"
  end

  def path_parameters_text
    self.path_parameters.collect{ |papa| "#{papa.name}\t#{papa.type}\t#{papa.description}" }.join("\n")
  end

  def path_parameters_text=(data)
    lines = data.split("\n").collect(&:strip).reject{ |line| line == '' }
    papas = lines.collect do |line|
      name, type, description = line.split("\t").collect(&:strip).reject{ |token| token == '' }
      self.path_parameters.build({ name: name, type: type, description: description })
    end
    self.path_parameters.each do |old_papa|
      if not papas.any?{ |papa| papa.name == old_papa.name }
        old_papa.destroy
      end
    end
    papas.each do |papa|
      old_papa = self.path_parameters.detect{ |old_papa| old_papa.name == papa.name }
      if old_papa.present?
        old_papa.update_attributes(papa.attributes.reject{ |key| ['id', 'created_at', 'updated_at'].include?(key) })
      else
        papa.save!
      end
    end
  end

  # https://docs.google.com/spreadsheets/d/1Lne2Jz34J9mJ7shlVqglEy12JlmXtweeqHsHXTXHzaM/edit?ts=570c4d57#gid=1204854372
  # copy all and paste into lib/ringcentral-endpoints.csv
  # remove header line
  def load_rc_data! # load RingCentral data
    data = File.read(Rails.root.join('lib/ringcentral-endpoints.csv'))
    data = data.gsub('/{version}', '/v1.0')
      .gsub(%r</([^/]+)/(?:~|\{id\})>){ |m| "/#{$1}/{#{$1.gsub('-', '_').camelize(:lower)}Id}" }
      .gsub(%r</([^/]+)/\{key\}>){ |m| "/#{$1}/{#{$1.gsub('-', '_').camelize(:lower)}Key}" }
    lines = data.split(/[\r\n]+/).collect(&:strip).reject{ |line| line == '' }
    lines.uniq.each do |line|
      method, uri, name, batch, user_plan_group, app_permission, user_permission, since, style, visibility, status, api_group, api_subgroup, name_for_reports, service_name, priority = line.split("\t").collect(&:strip)
      # create paths
      path = self.paths.find_by_uri(uri)
      if path.nil?
        path = self.paths.build(uri: uri)
        path.save!
      end
      # create verbs
      verb = path.verbs.find_by_name(name)
      if verb.nil?
        verb = path.verbs.build(method: method, name: name,
          batch: batch == 'Yes', visibility: visibility, status: status)
        verb.save!
      end
    end
  end
end
