class PathParametersController < ApplicationController
  def edit
    @spec = Specification.find(params[:specification_id])
  end

  def update
    spec = Specification.find(params[:specification_id])
    spec.path_parameters_text = params[:path_parameters_text]
    spec.save!
    spec.update_properties!
    redirect_to specification_url(spec, anchor: 'path_parameters')
  end
end
