class Specification < ActiveRecord::Base
  default_scope { order("title ASC") }

  validates :version, presence: true, uniqueness: { scope: :title}
  validates :title, presence: true
  has_many :models, dependent: :destroy
  has_many :paths, dependent: :destroy
  has_many :path_parameters, dependent: :destroy

  def display_name
    "#{title} #{version}"
  end

  require_dependency 'util/properties_model'

  def update_properties!
    PropertiesModel.update_properties!(path_parameters, parse_properties)
  end

  def parse_properties
    PropertiesModel.parse(path_parameters_text, PathParameter).collect do |item|
      item.specification = self
      item
    end
  end

  def swagger(editions = ['Basic'])
    result = {
      swagger: '2.0',
      info: {
        version: version,
        title: title,
        description: description,
        termsOfService: termsOfService,
      },
      host: host,
      basePath: basePath,
      schemes: schemes.split(/\s+/).reject(&:blank?),
      produces: produces.split(/\s+/).reject(&:blank?),
      consumes: consumes.split(/\s+/).reject(&:blank?),
      securityDefinitions: {
        oauth: {
          type: 'oauth2',
          flow: 'accessCode',
          authorizationUrl: 'https://platform.devtest.ringcentral.com/restapi/oauth/authorize',
          tokenUrl: 'https://platform.devtest.ringcentral.com/restapi/oauth/token',
          scopes: {
            default: 'default permissions',
          },
        },
      },
      security: [{
        oauth: ['default'],
      },],
      parameters: PathParameter.swagger,
      definitions: Model.swagger,
      paths: {},
    }
    paths.each do |path|
      path_swagger = path.swagger(editions)
      if path_swagger.present?
        result[:paths][path.uri] = path_swagger
      end
    end
    result = JSON[result.to_json] # stringify_keys recursively: https://gist.github.com/mkuhnt/6815250
    result
  end
end
