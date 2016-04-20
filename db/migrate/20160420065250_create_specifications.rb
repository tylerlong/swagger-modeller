class CreateSpecifications < ActiveRecord::Migration
  def change
    create_table :specifications do |t|
      t.string :version
      t.string :title
      t.string :description
      t.string :termsOfService
      t.string :host
      t.string :basePath
      t.string :schemes
      t.string :produces
      t.string :consumes
      t.timestamps null: false
    end
  end
end
