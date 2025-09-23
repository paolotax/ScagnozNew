class CreateAnagraficheBase < ActiveRecord::Migration[8.1]
  def change
    create_table :magazzini do |t|
      t.string :nome, null: false
      t.string :codice, null: false, limit: 10
      t.boolean :attivo, null: false, default: true
      t.timestamps
    end
    add_index :magazzini, :codice, unique: true

    create_table :articoli do |t|
      t.string :sku, null: false, limit: 32        # ISBN o SKU
      t.string :titolo, null: false
      t.string :autore
      t.string :editore
      t.string :barcode
      t.string :unita_misura, null: false, default: "pz"
      t.boolean :attivo, null: false, default: true
      t.timestamps
    end
    add_index :articoli, :sku, unique: true

    create_table :soggetti do |t|
      t.string :ragione_sociale, null: false
      t.string :partita_iva
      t.string :codice_fiscale
      t.string :email
      t.string :telefono
      t.string :tipo, null: false, default: "generico" # cliente, fornitore, generico
      t.timestamps
    end
    add_index :soggetti, [:tipo, :ragione_sociale]
  end
end
