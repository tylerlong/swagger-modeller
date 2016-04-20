class CreateSpecifications < ActiveRecord::Migration
  def change
    create_table :specifications do |t|
      t.string :version, null: false
      t.string :title, null: false
      t.string :description
      t.string :termsOfService
      t.string :host
      t.string :basePath
      t.string :schemes
      t.string :produces
      t.string :consumes
      t.timestamps null: false
    end
    add_index :specifications, [:version, :title], unique: true
  end
end
