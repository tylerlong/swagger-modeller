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

  def destroy
    Verb.find(params[:id]).destroy
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    redirect_to specification_path_url(spec, path)
  end

  def edit
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:id])
  end

  def update
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    verb = Verb.find(params[:id])
    verb.update_attributes(verb_params)
    redirect_to specification_path_verb_url(spec, path, verb)
  end

  private

  def verb_params
    result = params.permit(:name, :since, :description, :visibility, :method, :api_group, :batch, :status, :path_id)
    result[:batch] = result[:batch] == 'Yes'
    return result
  end
end
