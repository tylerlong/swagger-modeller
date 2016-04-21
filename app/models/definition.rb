class Definition < ActiveRecord::Base
  validates :specification_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :specification_id}
  belongs_to :specification
  has_many :properties, dependent: :destroy

  def update_properties!
    new_props = parse_properties
    properties.each do |prop|
      if not new_props.any?{ |new_prop| new_prop.name == prop.name }
        prop.destroy # destroy
      end
    end
    new_props.each do |new_prop|
      prop = properties.detect{ |prop| prop.name == new_prop.name }
      if prop.present?
        prop.update_attributes(new_prop.attributes.reject{ |key| ['id', 'created_at', 'updated_at'].include?(key) }) # update
      else
        new_prop.save! # create
      end
    end
  end

  def parse_properties
    rows = properties_text.split("\n").collect(&:strip).reject{ |row| row.blank? }
    props = rows.collect{ |row| Property.parse(row) }.reject{ |prop| prop == nil }
    props.each { |prop| prop.definition = self }
    return props
  end
end
