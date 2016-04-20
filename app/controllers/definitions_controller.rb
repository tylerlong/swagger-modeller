class DefinitionsController < ApplicationController
  def new
    @spec = Specification.find(params[:specification_id])
  end
end
