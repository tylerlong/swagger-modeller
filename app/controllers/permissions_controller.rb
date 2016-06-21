class PermissionsController < ApplicationController
  def edit
    @spec = Specification.find(params[:specification_id])
  end

  def update
    spec = Specification.find(params[:specification_id])
    spec.permissions_text = params[:permissions_text]
    spec.save!
    spec.update_permissions!
    redirect_to specification_url(spec, anchor: 'permissions')
  end
end
