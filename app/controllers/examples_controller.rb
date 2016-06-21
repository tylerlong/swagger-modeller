class ExamplesController < ApplicationController
  def new
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:verb_id])
  end

  def create
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    verb = Verb.find(params[:verb_id])
    example = Example.new(example_params)
    example.save!
    redirect_to specification_path_verb_url(spec, path, verb, anchor: 'examples')
  end

  def destroy
    Example.find(params[:id]).destroy
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    verb = Verb.find(params[:verb_id])
    redirect_to specification_path_verb_url(spec, path, verb, anchor: 'examples')
  end

  def edit
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:verb_id])
    @example = Example.find(params[:id])
  end

  def update
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    verb = Verb.find(params[:verb_id])
    example = Example.find(params[:id])
    example.update_attributes(example_params)
    redirect_to specification_path_verb_url(spec, path, verb, anchor: 'examples')
  end

  private

  def example_params
    result = params.permit(:name, :description, :request, :response, :verb_id)
    return result
  end
end
