class Specification < ActiveRecord::Base
  default_scope { order("title ASC") }

  validates :version, presence: true, uniqueness: { scope: :title}
  validates :title, presence: true
  has_many :models, dependent: :destroy
  has_many :paths, dependent: :destroy
  has_many :path_parameters, dependent: :destroy
  has_many :permissions, dependent: :destroy

  def display_name
    "#{title} #{version}"
  end

  include ModelUtil

  def used_permissions
    paths.collect(&:verbs).flatten.collect do |verb|
      verb.permissions.split(",").collect(&:strip).reject(&:blank?)
    end.flatten.uniq
  end
  def defined_permissions
    permissions.collect(&:name).uniq
  end
  def used_undefined_permissions
    used_permissions - defined_permissions
  end
  def defined_unused_permissions
    defined_permissions - used_permissions
  end

  def used_path_parameters
    paths.collect{ |path| path.uri.scan(/\{([a-zA-Z]+?)\}/).flatten }.flatten.uniq
  end
  def defined_path_parameters
    path_parameters.collect(&:name).uniq
  end
  def used_undefined_path_parameters
    used_path_parameters - defined_path_parameters
  end
  def defined_unused_path_parameters
    defined_path_parameters - used_path_parameters
  end

  def empty_paths
    paths.select{ |path| path.verbs.blank? }
  end

  def unreferenced_models
    models.select{ |model| model.referenced_by_model.blank? && model.referenced_by_request_body.blank? && model.referenced_by_response_body.blank? }
  end
  def undefined_models
    props = models.collect(&:model_properties).flatten + paths.collect(&:verbs).flatten.collect(&:request_body_properties).flatten
    props += paths.collect(&:verbs).flatten.collect(&:response_body_properties).flatten
    props.collect do |prop| # used model
      if !['integer', 'string', 'boolean', 'array'].include?(prop.data_type)
        prop.data_type
      elsif prop.data_type == 'array' && !['string'].include?(prop.format)
        prop.format
      else
        nil
      end
    end.reject(&:nil?).reject{ |model| models.find_by_name(model).present? }.uniq
  end

  def no_example_verbs
    paths.collect(&:verbs).flatten.select{ |verb| verb.examples.blank? }
  end

  def update_path_parameters!
    Specification.update_properties!(path_parameters, parse_path_parameters)
  end

  def parse_path_parameters
    Specification.parse(path_parameters_text, PathParameter).collect do |item|
      item.specification = self
      item
    end
  end

  def update_permissions!
    Specification.update_properties!(permissions, parse_permissions)
  end

  def parse_permissions
    lines = permissions_text.strip.split("\n").collect(&:strip).reject(&:blank?)
    perms = lines.collect do |line|
      tokens = line.split("\t").collect(&:strip).reject(&:blank?)
      if tokens.length == 2
        perm = Permission.new
        perm.name = tokens[0]
        perm.description = tokens[1]
        perm.specification = self
        perm
      else
        nil
      end
    end
    perms.reject(&:nil?)
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
      parameters: Hash[path_parameters.collect{ |pp| [pp.name, { name: pp.name, in: 'path', required: true }.merge(pp.swagger)] }],
      definitions: Hash[models.collect{ |model| [model.name, model.swagger] }],
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
