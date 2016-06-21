class CreateExamples < ActiveRecord::Migration
  def change
    create_table :examples do |t|
      t.integer :verb_id, null: false
      t.string :name, default: 'Example'
      t.string :description, default: ''
      t.string :request, default: ''
      t.string :response, default: ''
      t.timestamps null: false
    end
    add_index :examples, [:verb_id, :name], unique: true
  end
end
