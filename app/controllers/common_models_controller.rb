class CommonModelsController < ApplicationController
  def new
    @spec = Specification.find(params[:specification_id])
  end

  def show
    @spec = Specification.find(params[:specification_id])
    @comm = CommonModel.find(params[:id])
  end

  def create
    comm = CommonModel.new(comm_params)
    comm.save!
    comm.update_properties!
    spec = Specification.find(params[:specification_id])
    redirect_to specification_url(spec, anchor: 'models')
  end

  def edit
    @spec = Specification.find(params[:specification_id])
    @comm = CommonModel.find(params[:id])
  end

  def update
    comm = CommonModel.find(params[:id])
    comm.update_attributes(comm_params)
    comm.update_properties!
    spec = Specification.find(params[:specification_id])
    redirect_to specification_url(spec, anchor: 'models')
  end

  def destroy
    CommonModel.find(params[:id]).destroy
    spec = Specification.find(params[:specification_id])
    redirect_to specification_url(spec, anchor: 'models')
  end

  private

  def comm_params
    result = params.permit(:name, :properties_text, :specification_id)
    result[:name] = result[:name].gsub(/\s+/, '')
    result
  end
end
