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
  end
end
