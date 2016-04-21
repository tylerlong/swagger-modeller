class DefinitionsController < ApplicationController
  def new
    @spec = Specification.find(params[:specification_id])
  end

  def create
    defi = Definition.new(defi_params)
    defi.save!
    spec = Specification.find(params[:specification_id])
    redirect_to spec
  end

  def destroy
    defi = Definition.find(params[:id]).destroy
    spec = Specification.find(params[:specification_id])
    redirect_to spec
  end

  private

  def defi_params
    params.permit(:name, :description, :specification_id)
  end
end
