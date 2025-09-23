class CreateNumeratori < ActiveRecord::Migration[8.1]
  def change
    create_table :numeratori do |t|
      t.integer :anno, null: false
      t.integer :progressivo, null: false, default: 0
      t.integer :tipo, null: false # come Documento.tipi
      t.timestamps
    end
    add_index :numeratori, [:anno, :tipo], unique: true
  end
end
