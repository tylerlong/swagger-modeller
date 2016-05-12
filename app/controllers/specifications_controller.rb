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

  def swagger
    spec = Specification.find(params[:id])
    editions = (params[:v] || 'Basic').split(',').collect(&:strip)
    respond_to do |format|
      format.yaml { render text: spec.swagger(editions).to_yaml + "\n", content_type: 'text/yaml' }
      format.json { render text: JSON.pretty_generate(spec.swagger(editions)) + "\n", content_type: 'text/json' }
    end
  end

  private

  def spec_params
    params.permit(:version, :title, :description,
      :termsOfService, :host, :basePath, :schemes, :consumes, :produces)
  end
end
