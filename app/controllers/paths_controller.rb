class PathsController < ApplicationController
  def show
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:id])
  end

  def edit
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:id])
  end

  def destroy
    Path.find(params[:id]).destroy
    spec = Specification.find(params[:specification_id])
    redirect_to specification_url(spec, anchor: 'paths')
  end

  def update
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:id])
    path.update_attributes(path_params)
    redirect_to specification_path_url(spec, path)
  end

  private

  def path_params
    params.permit(:uri)
  end
end
