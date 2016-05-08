class ResponseBodyPropertiesController < ApplicationController
  def edit
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:verb_id])
  end

  def update
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:verb_id])
    @verb.response_body_text = params[:response_body_text]
    @verb.save!
    redirect_to specification_path_verb_path(@spec, @path, @verb, anchor: 'response_body')
  end
end
