# Verb is a synonym for Request

class Verb < ActiveRecord::Base
  validates :path_id, presence: true
  validates :method, presence: true
  validates :visibility, presence: true
  validates :name, presence: true, uniqueness: { scope: :path_id }
  belongs_to :path
  has_many :query_parameters, dependent: :destroy

  def query_parameters_text=(value)
    write_attribute(:query_parameters_text, value)
    new_qps = parse_parameters
    query_parameters.each do |qp|
      if not new_qps.any? { |new_qp| new_qp.name == qp.name }
        qp.destroy # delete
      end
    end
    new_qps.each do |new_qp|
      qp = query_parameters.detect{ |qp| qp.name == new_qp.name }
      if qp.present?
        qp.update_attributes(new_qp.attributes.reject{ |key| ['id', 'created_at', 'updated_at'].include?(key) }) # update
      else
        new_qp.save! #create
      end
    end
  end

  def parse_parameters
    rows = query_parameters_text.split("\n").collect(&:strip).reject{ |row| row.blank? }
    qps = rows.collect{ |row| QueryParameter.parse(row) }.reject{ |qp| qp == nil }.each_with_index.collect do |qp, index|
      qp.position = index
      qp.verb = self
      qp
    end
    return qps
  end
end
