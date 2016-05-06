class VerbsController < ApplicationController
  def show
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:id])
  end

  def new
  end
end
