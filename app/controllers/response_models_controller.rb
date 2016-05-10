class ResponseModelsController < ApplicationController
  def new
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:verb_id])
  end

  def create
    rspm = ResponseModel.new(rspm_params)
    rspm.save!
    rspm.update_properties!
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    verb = Verb.find(params[:verb_id])
    redirect_to specification_path_verb_url(spec, path, verb, anchor: 'response_body')
  end

  def edit
    @spec = Specification.find(params[:specification_id])
    @path = Path.find(params[:path_id])
    @verb = Verb.find(params[:verb_id])
    @rspm = ResponseModel.find(params[:id])
  end

  def update
    rspm = ResponseModel.find(params[:id])
    rspm.update_attributes(rspm_params)
    rspm.update_properties!
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    verb = Verb.find(params[:verb_id])
    redirect_to specification_path_verb_url(spec, path, verb, anchor: 'response_body')
  end

  def destroy
    ResponseModel.find(params[:id]).destroy
    spec = Specification.find(params[:specification_id])
    path = Path.find(params[:path_id])
    verb = Verb.find(params[:verb_id])
    redirect_to specification_path_verb_url(spec, path, verb, anchor: 'response_body')
  end

  private

  def rspm_params
    result = params.permit(:name, :properties_text, :verb_id)
    result[:name] = result[:name].gsub(/\s+/, '')
    result
  end
end
