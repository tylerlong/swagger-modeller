class SpecificationsController < ApplicationController
  def index
  end

  def new
  end

  def create
    spec = Specification.new(spec_params)
    spec.save!
    redirect_to specifications_url
  end

  def show
    @spec = Specification.find(params[:id])
  end

  def edit
    @spec = Specification.find(params[:id])
  end

  private

  def spec_params
    params.permit(:version, :title, :description,
      :termsOfService, :host, :basePath, :schemes, :consumes, :produces)
  end
end
