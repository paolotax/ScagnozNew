# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_09_18_213341) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "articoli", force: :cascade do |t|
    t.boolean "attivo", default: true, null: false
    t.string "autore"
    t.string "barcode"
    t.datetime "created_at", null: false
    t.string "editore"
    t.string "sku", limit: 32, null: false
    t.string "titolo", null: false
    t.string "unita_misura", default: "pz", null: false
    t.datetime "updated_at", null: false
    t.index ["sku"], name: "index_articoli_on_sku", unique: true
  end

  create_table "causali_magazzino", force: :cascade do |t|
    t.boolean "attiva", default: true, null: false
    t.string "codice", limit: 6, null: false
    t.datetime "created_at", null: false
    t.text "descrizione"
    t.boolean "di_sistema", default: false, null: false
    t.string "nome", null: false
    t.boolean "richiede_cliente", default: false, null: false
    t.boolean "richiede_fornitore", default: false, null: false
    t.integer "segno_movimento", default: 0, null: false
    t.integer "tipo_movimento", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["codice"], name: "index_causali_magazzino_on_codice", unique: true
    t.check_constraint "segno_movimento = ANY (ARRAY['-1'::integer, 0, 1])", name: "causali_segno_chk"
  end

  create_table "documenti", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data_documento", null: false
    t.bigint "magazzino_id"
    t.string "numero", null: false
    t.bigint "soggetto_id"
    t.string "stato", default: "bozza", null: false
    t.integer "tipo", default: 0, null: false
    t.decimal "totale_imposta", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "totale_lordo", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "totale_netto", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["magazzino_id"], name: "index_documenti_on_magazzino_id"
    t.index ["soggetto_id"], name: "index_documenti_on_soggetto_id"
    t.index ["stato"], name: "index_documenti_on_stato"
    t.index ["tipo", "numero"], name: "index_documenti_on_tipo_and_numero", unique: true
  end

  create_table "giacenze", force: :cascade do |t|
    t.bigint "articolo_id", null: false
    t.datetime "created_at", null: false
    t.bigint "magazzino_id", null: false
    t.decimal "quantita", precision: 14, scale: 3, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["articolo_id"], name: "index_giacenze_on_articolo_id"
    t.index ["magazzino_id", "articolo_id"], name: "index_giacenze_on_magazzino_id_and_articolo_id", unique: true
    t.index ["magazzino_id"], name: "index_giacenze_on_magazzino_id"
  end

  create_table "magazzini", force: :cascade do |t|
    t.boolean "attivo", default: true, null: false
    t.string "codice", limit: 10, null: false
    t.datetime "created_at", null: false
    t.string "nome", null: false
    t.datetime "updated_at", null: false
    t.index ["codice"], name: "index_magazzini_on_codice", unique: true
  end

  create_table "movimenti_magazzino", force: :cascade do |t|
    t.bigint "causale_magazzino_id", null: false
    t.datetime "created_at", null: false
    t.date "data_movimento", null: false
    t.bigint "documento_id"
    t.bigint "magazzino_id", null: false
    t.text "note"
    t.string "riferimento_esterno"
    t.datetime "updated_at", null: false
    t.index ["causale_magazzino_id"], name: "index_movimenti_magazzino_on_causale_magazzino_id"
    t.index ["documento_id"], name: "index_movimenti_magazzino_on_documento_id"
    t.index ["magazzino_id"], name: "index_movimenti_magazzino_on_magazzino_id"
  end

  create_table "numeratori", force: :cascade do |t|
    t.integer "anno", null: false
    t.datetime "created_at", null: false
    t.integer "progressivo", default: 0, null: false
    t.integer "tipo", null: false
    t.datetime "updated_at", null: false
    t.index ["anno", "tipo"], name: "index_numeratori_on_anno_and_tipo", unique: true
  end

  create_table "righe_documento", force: :cascade do |t|
    t.decimal "aliquota_iva", precision: 5, scale: 2, default: "0.0", null: false
    t.bigint "articolo_id", null: false
    t.datetime "created_at", null: false
    t.bigint "documento_id", null: false
    t.string "note"
    t.decimal "prezzo_unitario", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "quantita", precision: 12, scale: 3, null: false
    t.decimal "quantita_evasa", precision: 12, scale: 3, default: "0.0", null: false
    t.integer "stato", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["articolo_id"], name: "index_righe_documento_on_articolo_id"
    t.index ["documento_id"], name: "index_righe_documento_on_documento_id"
    t.check_constraint "quantita >= 0::numeric", name: "righe_documento_qta_pos_chk"
    t.check_constraint "quantita_evasa >= 0::numeric AND quantita_evasa <= quantita", name: "righe_documento_evasa_le_quantita_chk"
  end

  create_table "righe_movimento_magazzino", force: :cascade do |t|
    t.bigint "articolo_id", null: false
    t.datetime "created_at", null: false
    t.bigint "movimento_magazzino_id", null: false
    t.decimal "prezzo_unitario", precision: 12, scale: 4
    t.decimal "quantita", precision: 12, scale: 3, null: false
    t.bigint "riga_documento_id"
    t.datetime "updated_at", null: false
    t.index ["articolo_id"], name: "index_righe_movimento_magazzino_on_articolo_id"
    t.index ["movimento_magazzino_id"], name: "index_righe_movimento_magazzino_on_movimento_magazzino_id"
    t.index ["riga_documento_id"], name: "index_righe_movimento_magazzino_on_riga_documento_id"
    t.check_constraint "quantita > 0::numeric", name: "righe_mov_mag_qta_pos_chk"
  end

  create_table "soggetti", force: :cascade do |t|
    t.string "codice_fiscale"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "partita_iva"
    t.string "ragione_sociale", null: false
    t.string "telefono"
    t.string "tipo", default: "generico", null: false
    t.datetime "updated_at", null: false
    t.index ["tipo", "ragione_sociale"], name: "index_soggetti_on_tipo_and_ragione_sociale"
  end

  add_foreign_key "documenti", "magazzini"
  add_foreign_key "documenti", "soggetti"
  add_foreign_key "giacenze", "articoli"
  add_foreign_key "giacenze", "magazzini"
  add_foreign_key "movimenti_magazzino", "causali_magazzino"
  add_foreign_key "movimenti_magazzino", "documenti"
  add_foreign_key "movimenti_magazzino", "magazzini"
  add_foreign_key "righe_documento", "articoli"
  add_foreign_key "righe_documento", "documenti"
  add_foreign_key "righe_movimento_magazzino", "articoli"
  add_foreign_key "righe_movimento_magazzino", "movimenti_magazzino"
  add_foreign_key "righe_movimento_magazzino", "righe_documento"
end
