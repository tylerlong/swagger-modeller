class DefinitionsController < ApplicationController
  def new
    @spec = Specification.find(params[:specification_id])
  end

  def create
    params[:name] = params[:name].gsub(/\s+/, '')
    defi = Definition.new(defi_params)
    defi.save!
    defi.update_properties!
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

  def update
    params[:name] = params[:name].gsub(/\s+/, '')
    spec = Specification.find(params[:specification_id])
    defi = Definition.find(params[:id])
    defi.update_attributes(defi_params)
    defi.update_properties!
    redirect_to specification_definition_url(spec, defi)
  end

  private

  def defi_params
    params.permit(:name, :description, :properties_text, :specification_id)
  end
end
