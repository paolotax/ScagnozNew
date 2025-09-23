# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# puts "🌱 Seeding database..."

# # Creazione magazzini
# magazzino_principale = Magazzino.find_or_create_by!(codice: "MAG01") do |m|
#   m.nome = "Magazzino Principale"
#   m.attivo = true
# end

# magazzino_secondario = Magazzino.find_or_create_by!(codice: "MAG02") do |m|
#   m.nome = "Magazzino Secondario"
#   m.attivo = true
# end

# puts "✅ Magazzini creati"

# # Creazione causali magazzino
# causali = [
#   { codice: "CA", nome: "Carico Acquisto", tipo_movimento: 0, segno_movimento: 1, attiva: true, di_sistema: true },
#   { codice: "CV", nome: "Carico Vendita", tipo_movimento: 0, segno_movimento: 1, attiva: true, di_sistema: true },
#   { codice: "SC", nome: "Scarico Vendita", tipo_movimento: 1, segno_movimento: -1, attiva: true, di_sistema: true },
#   { codice: "SR", nome: "Scarico Reso", tipo_movimento: 1, segno_movimento: -1, attiva: true, di_sistema: true },
#   { codice: "TR", nome: "Trasferimento", tipo_movimento: 2, segno_movimento: 0, attiva: true, di_sistema: true }
# ]

# causali.each do |causale_data|
#   CausaleMagazzino.find_or_create_by!(codice: causale_data[:codice]) do |c|
#     c.assign_attributes(causale_data)
#   end
# end

# puts "✅ Causali magazzino create"

# # Creazione soggetti
# clienti = [
#   { ragione_sociale: "Libreria Centrale", tipo: "cliente", email: "info@libreriacentrale.it", telefono: "02-1234567" },
#   { ragione_sociale: "Mondadori Store", tipo: "cliente", email: "ordini@mondadoristore.it", telefono: "02-7654321" },
#   { ragione_sociale: "Feltrinelli", tipo: "cliente", email: "acquisti@feltrinelli.it", telefono: "02-9876543" }
# ]

# fornitori = [
#   { ragione_sociale: "Editore Mondadori", tipo: "fornitore", email: "vendite@mondadori.it", telefono: "02-1111111" },
#   { ragione_sociale: "Editore Rizzoli", tipo: "fornitore", email: "ordini@rizzoli.it", telefono: "02-2222222" },
#   { ragione_sociale: "Editore Einaudi", tipo: "fornitore", email: "commerciale@einaudi.it", telefono: "02-3333333" }
# ]

# (clienti + fornitori).each do |soggetto_data|
#   Soggetto.find_or_create_by!(ragione_sociale: soggetto_data[:ragione_sociale]) do |s|
#     s.assign_attributes(soggetto_data)
#   end
# end

# puts "✅ Soggetti creati"

# # Creazione articoli (libri)
# libri = [
#   { sku: "9788804668237", titolo: "Il Nome della Rosa", autore: "Umberto Eco", editore: "Bompiani", barcode: "9788804668237" },
#   { sku: "9788807901923", titolo: "1984", autore: "George Orwell", editore: "Mondadori", barcode: "9788807901923" },
#   { sku: "9788806220045", titolo: "Il Gattopardo", autore: "Giuseppe Tomasi di Lampedusa", editore: "Feltrinelli", barcode: "9788806220045" },
#   { sku: "9788804668238", titolo: "Se questo è un uomo", autore: "Primo Levi", editore: "Einaudi", barcode: "9788804668238" },
#   { sku: "9788807901924", titolo: "I Promessi Sposi", autore: "Alessandro Manzoni", editore: "Mondadori", barcode: "9788807901924" }
# ]

# libri.each do |libro_data|
#   Articolo.find_or_create_by!(sku: libro_data[:sku]) do |a|
#     a.assign_attributes(libro_data)
#     a.attivo = true
#   end
# end

# puts "✅ Articoli creati"

# # Creazione giacenze iniziali
# Articolo.all.each do |articolo|
#   # Giacenza nel magazzino principale
#   Giacenza.find_or_create_by!(magazzino: magazzino_principale, articolo: articolo) do |g|
#     g.quantita = rand(10..100)
#   end

#   # Giacenza nel magazzino secondario
#   Giacenza.find_or_create_by!(magazzino: magazzino_secondario, articolo: articolo) do |g|
#     g.quantita = rand(5..50)
#   end
# end

puts "✅ Giacenze iniziali create"# Pulisci solo se la tabella esiste e ha record
if CausaleMagazzino.table_exists? && CausaleMagazzino.any?
  CausaleMagazzino.destroy_all
end

causali = [
  {
    codice: "CA",
    nome: "Acquisto da fornitore",
    descrizione: "Carico derivante da fattura o DDT fornitore",
    tipo_movimento: 0, # carico
    segno_movimento: 1,
    attiva: true,
    richiede_fornitore: true,
    richiede_cliente: false,
    di_sistema: true
  },
  {
    codice: "CI",
    nome: "Carico iniziale",
    descrizione: "Inserimento giacenze iniziali",
    tipo_movimento: 0, # carico
    segno_movimento: 1,
    attiva: true,
    richiede_fornitore: false,
    richiede_cliente: false,
    di_sistema: true
  },
  {
    codice: "RC",
    nome: "Reso da cliente",
    descrizione: "Rientro merce da cliente",
    tipo_movimento: 0, # carico
    segno_movimento: 1,
    attiva: true,
    richiede_fornitore: false,
    richiede_cliente: true,
    di_sistema: false
  },
  {
    codice: "VE",
    nome: "Vendita a cliente",
    descrizione: "Scarico derivante da vendita",
    tipo_movimento: 1, # scarico
    segno_movimento: -1,
    attiva: true,
    richiede_fornitore: false,
    richiede_cliente: true,
    di_sistema: true
  },
  {
    codice: "RF",
    nome: "Reso a fornitore",
    descrizione: "Reso merce a fornitore",
    tipo_movimento: 1, # scarico
    segno_movimento: -1,
    attiva: true,
    richiede_fornitore: true,
    richiede_cliente: false,
    di_sistema: false
  },
  {
    codice: "OM",
    nome: "Omaggi / Campioni",
    descrizione: "Scarico gratuito (ad esempio libri dati a docenti)",
    tipo_movimento: 1, # scarico
    segno_movimento: -1,
    attiva: true,
    richiede_fornitore: false,
    richiede_cliente: false,
    di_sistema: false
  },
  {
    codice: "INP",
    nome: "Rettifica inventario (carico)",
    descrizione: "Aggiustamento positivo inventariale",
    tipo_movimento: 0, # carico
    segno_movimento: 1,
    attiva: true,
    richiede_fornitore: false,
    richiede_cliente: false,
    di_sistema: false
  },
  {
    codice: "INN",
    nome: "Rettifica inventario (scarico)",
    descrizione: "Aggiustamento negativo inventariale",
    tipo_movimento: 1, # scarico
    segno_movimento: -1,
    attiva: true,
    richiede_fornitore: false,
    richiede_cliente: false,
    di_sistema: false
  },
  {
    codice: "TR",
    nome: "Trasferimento tra magazzini",
    descrizione: "Movimento neutro da un deposito a un altro",
    tipo_movimento: 2, # trasferimento
    segno_movimento: 0,
    attiva: true,
    richiede_fornitore: false,
    richiede_cliente: false,
    di_sistema: false
  },
  {
    codice: "CD",
    nome: "Conto deposito",
    descrizione: "Merce inviata in deposito presso cliente",
    tipo_movimento: 1, # scarico
    segno_movimento: -1,
    attiva: true,
    richiede_fornitore: false,
    richiede_cliente: true,
    di_sistema: false
  }
]

causali.each do |causale_data|
  CausaleMagazzino.find_or_create_by(codice: causale_data[:codice]) do |causale|
    causale.assign_attributes(causale_data)
  end
end

puts "✅ Causali di magazzino create: #{CausaleMagazzino.count}"






puts "🎉 Database seeded successfully!"
