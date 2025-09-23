class CreateCausaliMagazzino < ActiveRecord::Migration[8.1]
  def change
    create_table :causali_magazzino do |t|
      t.string  :codice, null: false, limit: 6
      t.string  :nome, null: false
      t.text    :descrizione
      t.integer :tipo_movimento, null: false, default: 0 # 0=carico 1=scarico 2=trasferimento
      t.integer :segno_movimento, null: false, default: 0 # -1/0/+1
      t.boolean :attiva, null: false, default: true
      t.boolean :di_sistema, null: false, default: false
      t.boolean :richiede_fornitore, null: false, default: false
      t.boolean :richiede_cliente, null: false, default: false
      t.timestamps
    end
    add_index :causali_magazzino, :codice, unique: true
  end
end
