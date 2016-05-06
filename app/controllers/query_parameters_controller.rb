class QueryParametersController < ApplicationController
  def edit
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:verb_id])
  end

  def update
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:verb_id])
    # todo: update query parameters
    redirect_to specification_path_verb_path(@spec, @path, @verb)
  end
end
