class DefinitionsController < ApplicationController
  def new
    @spec = Specification.find(params[:specification_id])
  end

  def create
    defi = Definition.new(defi_params)
    defi.save!
    params[:properties].split("\n").collect(&:strip).reject{ |row| row == '' }.each do |row|
      prop = Property.parse(row)
      if prop.present?
        prop.definition = defi
        prop.save!
      end
    end
    spec = Specification.find(params[:specification_id])
    redirect_to specification_definition_url(spec, defi)
  end

  def destroy
    defi = Definition.find(params[:id]).destroy
    spec = Specification.find(params[:specification_id])
    redirect_to specification_url(spec, anchor: 'definitions')
  end

  def show
    @spec = Specification.find(params[:specification_id])
    @defi = Definition.find(params[:id])
  end

  def edit
    @spec = Specification.find(params[:specification_id])
    @defi = Definition.find(params[:id])
  end

  private

  def defi_params
    params.permit(:name, :description, :specification_id)
  end
end
