class SpecificationsController < ApplicationController
  def index
  end

  def new
  end

  def dump
    sql = %x{sqlite3 #{Rails.root.join('db', 'development.sqlite3')} .dump}
    send_data sql, :filename => 'swagger_modeller.sql'
  end

  def create
    spec = Specification.new(spec_params)
    spec.save!
    redirect_to spec
  end

  def show
    @spec = Specification.find(params[:id])
  end

  def edit
    @spec = Specification.find(params[:id])
  end

  def destroy
    Specification.find(params[:id]).destroy
    redirect_to specifications_url
  end

  def update
    spec = Specification.find(params[:id])
    spec.update_attributes(spec_params)
    redirect_to spec
  end

  def swagger
    spec = Specification.find(params[:id])
    editions = (params[:v] || 'Basic').split(',').collect(&:strip)
    respond_to do |format|
      data = spec.swagger(editions)
      format.yaml { render text: data.to_yaml + "\n", content_type: 'text/yaml' }
      format.json { render text: JSON.pretty_generate(data) + "\n", content_type: 'text/json' }
    end
  end

  def validate
    @spec = Specification.find(params[:id])
  end

  def api_reference
    @spec = Specification.find(params[:id])
    respond_to do |format|
      format.md do
        render 'markdown/specification'
      end
      format.html do
        render 'markdown/specification', layout: 'markdown'
      end
    end
  end

  def api_explorer
    spec = Specification.find(params[:id])
    editions = (params[:v] || 'Basic').split(',').collect(&:strip)
    respond_to do |format|
      data = spec.swagger(editions)
      faxPost = data["paths"]["/restapi/v1.0/account/{accountId}/extension/{extensionId}/fax"]["post"]
      faxPost['consumes'] = ['multipart/mixed; boundary=Boundary_1_14413901_1361871080888']
      faxPost['parameters'] = [{ 'name' => 'body', 'in' => 'body', 'type' => 'string',
        'description' => 'Multi-part MIME consisting of one part JSON body and one part text. For the MIME boundary, in this UI, use "Boundary_1_14413901_1361871080888".',
        'default' => %{--Boundary_1_14413901_1361871080888
Content-Type: application/json

{
  "to":[{"phoneNumber":"18005630003"}],
  "faxResolution":"High"
}

--Boundary_1_14413901_1361871080888
Content-Type: text/plain

Hello World!

--Boundary_1_14413901_1361871080888--} }]
      format.yaml { render text: data.to_yaml + "\n", content_type: 'text/yaml' }
      format.json { render text: JSON.pretty_generate(data) + "\n", content_type: 'text/json' }
    end
  end

  private

  def spec_params
    params.permit(:version, :title, :description,
      :termsOfService, :host, :basePath, :schemes, :consumes, :produces)
  end
end
