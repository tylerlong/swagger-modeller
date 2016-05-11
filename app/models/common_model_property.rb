class CommonModelProperty < ActiveRecord::Base
  default_scope { order("position ASC") }

  self.inheritance_column = 'table_type' # http://stackoverflow.com/questions/11470011/activerecordsubclassnotfound
  validates :common_model_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :common_model_id }
  validates :type, presence: true
  validates :description, presence: true
  belongs_to :common_model

  require_dependency 'util/model_property'
  def self.parse(row)
    dict = ModelProperty.parse(row)
    dict.nil? ? nil : CommonModelProperty.new(dict)
  end

  def swagger
    result = {
      type: type,
      description: description,
    }
    if type == 'array'
      result[:items] = { type: format }
      if not ['integer', 'array', 'string', 'boolean'].include? format
        result[:items] = { "$ref" => '#/definitions/' + format }
      end
    end
    if not ['integer', 'array', 'string', 'boolean'].include? type # custom type
      result = { "$ref" => '#/definitions/' + type, description: description, }
    end
    if type == 'string' and format.start_with?("'") and format.end_with?("'") #enum
      result[:enum] = format.split('|').collect{ |word| word.gsub(/\A[\s']+|[\s']+\z/,'') }
    end
    if (type == 'string' and format == 'date-time') or (type == 'integer' and format.present?)
      result[:format] = format
    end
    result
  end
end
