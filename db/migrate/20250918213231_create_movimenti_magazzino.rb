class CreateMovimentiMagazzino < ActiveRecord::Migration[8.1]
  def change
    create_table :movimenti_magazzino do |t|
      t.date    :data_movimento, null: false
      t.references :magazzino, null: false, foreign_key: true
      t.references :causale_magazzino, null: false, foreign_key: true
      t.references :documento, null: true, foreign_key: true
      t.string :riferimento_esterno
      t.text   :note
      t.timestamps
    end

    create_table :righe_movimento_magazzino do |t|
      t.references :movimento_magazzino, null: false, foreign_key: true
      t.references :articolo, null: false, foreign_key: true
      t.decimal :quantita, precision: 12, scale: 3, null: false
      t.decimal :prezzo_unitario, precision: 12, scale: 4
      t.references :riga_documento, null: true, foreign_key: { to_table: :righe_documento }
      t.timestamps
    end

    create_table :giacenze do |t|
      t.references :magazzino, null: false, foreign_key: true
      t.references :articolo, null: false, foreign_key: true
      t.decimal :quantita, precision: 14, scale: 3, null: false, default: 0
      t.timestamps
    end
    add_index :giacenze, [:magazzino_id, :articolo_id], unique: true
  end
end
