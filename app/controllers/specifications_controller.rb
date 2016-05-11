class SpecificationsController < ApplicationController
  def index
  end

  def new
  end

  def create
    spec = Specification.new(spec_params)
    spec.save!
    redirect_to spec
  end

  def show
    @spec = Specification.find(params[:id])
  end

  def edit
    @spec = Specification.find(params[:id])
  end

  def destroy
    Specification.find(params[:id]).destroy
    redirect_to specifications_url
  end

  def update
    spec = Specification.find(params[:id])
    spec.update_attributes(spec_params)
    redirect_to spec
  end

  def swagger_json
    spec = Specification.find(params[:id])
    render json: spec.swagger
  end

  def swagger_yaml
    spec = Specification.find(params[:id])
    render text: spec.swagger.to_yaml + "\n", content_type: 'text/yaml'
  end

  private

  def spec_params
    params.permit(:version, :title, :description,
      :termsOfService, :host, :basePath, :schemes, :consumes, :produces)
  end
end
