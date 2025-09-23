class CreateDocumenti < ActiveRecord::Migration[8.1]
  def change
    create_table :documenti do |t|
      t.string  :numero, null: false
      t.date    :data_documento, null: false
      t.integer :tipo, null: false, default: 0
      # 0=ordine_cliente 1=ordine_fornitore 2=ddt 3=fattura 4=nota_credito 5=reso_fornitore 6=reso_cliente 7=ddt_trasferimento
      t.references :soggetto, null: true, foreign_key: true # cliente o fornitore a seconda del tipo
      t.references :magazzino, null: true, foreign_key: true # per DDT, carichi, etc.
      t.string  :stato, null: false, default: "bozza"
      t.decimal :totale_netto, precision: 12, scale: 2, null: false, default: 0
      t.decimal :totale_imposta, precision: 12, scale: 2, null: false, default: 0
      t.decimal :totale_lordo, precision: 12, scale: 2, null: false, default: 0
      t.timestamps
    end
    add_index :documenti, [:tipo, :numero], unique: true

    create_table :righe_documento do |t|
      t.references :documento, null: false, foreign_key: true
      t.references :articolo, null: false, foreign_key: true
      t.decimal :quantita, precision: 12, scale: 3, null: false
      t.decimal :quantita_evasa, precision: 12, scale: 3, null: false, default: 0
      t.decimal :prezzo_unitario, precision: 12, scale: 4, null: false, default: 0
      t.decimal :aliquota_iva, precision: 5, scale: 2, null: false, default: 0
      t.string  :note
      t.integer :stato, null: false, default: 0
      t.timestamps
    end
  end
end
