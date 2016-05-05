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
