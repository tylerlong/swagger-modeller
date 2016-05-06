class VerbsController < ApplicationController
  def show
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:id])
  end

  def new
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
  end

  def create
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    verb = Verb.new(verb_params)
    verb.save!
    redirect_to specification_path_verb_url(spec, path, verb)
  end

  private

  def verb_params
    result = params.permit(:name, :visibility, :method, :batch, :status, :path_id)
    result[:batch] = result[:batch] == 'Yes'
    return result
  end
end
