class ModelsController < ApplicationController
  def new
    @spec = Specification.find(params[:specification_id])
  end

  def show
    @spec = Specification.find(params[:specification_id])
    @model = Model.find(params[:id])
  end

  def create
    model = Model.new(model_params)
    model.save!
    model.update_properties!
    spec = Specification.find(params[:specification_id])
    redirect_to specification_model_url(spec, model)
  end

  def edit
    @spec = Specification.find(params[:specification_id])
    @model = Model.find(params[:id])
  end

  def update
    model = Model.find(params[:id])
    model.update_attributes(model_params)
    model.update_properties!
    spec = Specification.find(params[:specification_id])
    redirect_to specification_model_url(spec, model)
  end

  def destroy
    Model.find(params[:id]).destroy
    spec = Specification.find(params[:specification_id])
    redirect_to specification_url(spec, anchor: 'models')
  end

  def search
    model = Model.find_by_name(params[:name]) or not_found
    redirect_to specification_model_url(model.specification, model)
  end

  private

  def model_params
    result = params.permit(:name, :properties_text, :specification_id)
    result[:name] = result[:name].gsub(/\s+/, '')
    result
  end
end
